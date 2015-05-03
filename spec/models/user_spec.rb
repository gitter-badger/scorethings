require 'rails_helper'

RSpec.describe User do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)

  describe "creating a new user with oauth" do
    it "should create a new user account with defaults" do
      # there are 4 criterion, so the new user should have
      # 4 criterion_balance
      create(:positive_criterion)
      create(:negative_criterion)

      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:twitter] = {
          provider: 'twitter',
          uid: '2121',
          info: OmniAuth::AuthHash::InfoHash.new({
              nickname: 'alpha'
          })
      }
      auth = OmniAuth.config.mock_auth[:twitter]
      user = User.create_with_omniauth(auth)


      expect(user.twitter_uid).to eq('2121')
      expect(user.twitter_handle).to eq('alpha')
      expect(user.scores.length).to eq(0)
      expect(user.user_points_total).to_not be_nil
      expect(user.user_points_total.amount).to eq(1000)
      expect(user.remaining_points).to eq(1000)
    end
  end

  describe "creating scores" do
    it "should create an empty score for a subject that is a twitter handle" do
      user = build(:user_alpha)

      expect(user.scores.length).to eq(0)

      score = user.create_score(thing_type: 'twitter_handle', thing_value: 'josswhedon')

      expect(score).to_not be_nil
      expect(score.user).to eq(user)
      expect(score.thing).to_not be_nil
      expect(score.thing.type).to eq('twitter_handle')
      expect(score.thing.value).to eq('josswhedon')
      expect(score.calculate_total_score).to eq(0)

      expect(user.scores.length).to eq(1)
    end

    it "should create an empty score for a subject that is a twitter hashtag" do
      user = build(:user_alpha)

      expect(user.scores.length).to eq(0)

      score = user.create_score(thing_type: 'twitter_hashtag', thing_value: 'stelladoro')

      expect(score).to_not be_nil
      expect(score.user).to eq(user)
      expect(score.thing).to_not be_nil
      expect(score.thing.type).to eq('twitter_hashtag')
      expect(score.thing.value).to eq('stelladoro')
      expect(score.calculate_total_score).to eq(0)

      expect(user.scores.length).to eq(1)
    end

    it "should not create an empty score for an unsupported subject type" do
      user = build(:user_alpha)
      expect{
        user.create_score(thing_type: 'twitter_whatever', thing_value: 'whatitdo')
      }.to raise_error(Mongoid::Errors::Validations)
    end
  end

  describe "adding subscores to a score" do
    it "should add two subscores to a score" do
      user = create(:user_alpha)
      user.initialize_points_balance

      score = user.create_score(thing_type: 'twitter_handle', thing_value: 'grantmorrison')
      positive_criterion_1 = create(:positive_criterion)
      positive_criterion_2 = create(:positive_criterion)

      expect(score.subscores.length).to eq(0)
      user.add_or_change_subscore(score, positive_criterion_1, 65)
      user.add_or_change_subscore(score, positive_criterion_2, 52)
      expect(score.subscores.length).to eq(2)

      # total calculation functionality is tested in score_spec
    end

    it "should not allow a subscore to be added without a criterion" do
      user = create(:user_alpha)

      score = user.create_score(thing_type: 'twitter_handle', thing_value: 'grantmorrison')
      expect{
        user.add_or_change_subscore(score, nil, 65)
      }.to raise_error(ArgumentError)
    end

    it "should not allow a subscore to be added by a user who is not the score's user" do
      user = create(:user_alpha)
      user_bravo = create(:user_bravo)
      negative_criterion = create(:negative_criterion)

      score = user.create_score(thing_type: 'twitter_handle', thing_value: 'grantmorrison')
      expect{
        user_bravo.add_or_change_subscore(score, negative_criterion, 77)
      }.to raise_error(AccessDeniedError)
    end
  end

  describe "changing an existing subscore value" do
    it "should change the value of a subscore in a score with one subscore" do
      user = create(:user_alpha)
      user.initialize_points_balance

      score = user.create_score(thing_type: 'twitter_handle', thing_value: 'grantmorrison')
      positive_criterion = create(:positive_criterion)

      expect(score.subscores.length).to eq(0)
      user.add_or_change_subscore(score, positive_criterion, 50)
      expect(user.user_points_total.amount).to eq(1000)
      expect(user.remaining_points).to eq(950)
      expect(score.subscores.length).to eq(1)

      user.add_or_change_subscore(score, positive_criterion, 150)
      expect(user.user_points_total.amount).to eq(1000)
      expect(user.remaining_points).to eq(850)
      expect(score.subscores.length).to eq(1)
    end

    it "should change the value of a subscore in a score with two subscores" do
      user = create(:user_alpha)
      user.initialize_points_balance

      score = user.create_score(thing_type: 'twitter_handle', thing_value: 'grantmorrison')
      positive_criterion_1 = create(:positive_criterion)
      positive_criterion_2 = create(:positive_criterion)

      expect(score.subscores.length).to eq(0)
      user.add_or_change_subscore(score, positive_criterion_1, 50)
      user.add_or_change_subscore(score, positive_criterion_2, 20)
      expect(score.subscores.length).to eq(2)
      expect(score.subscores.where(criterion: positive_criterion_1).first.value).to eq(50)
      expect(score.subscores.where(criterion: positive_criterion_2).first.value).to eq(20)

      user.add_or_change_subscore(score, positive_criterion_1, 55)
      expect(score.subscores.where(criterion: positive_criterion_1).first.value).to eq(55)
      expect(score.subscores.where(criterion: positive_criterion_2).first.value).to eq(20)
    end
  end

  describe "calculating remaining points" do
    it "should calculate the remaining points when a subscore is added and changed" do
      funny_criterion = create(:positive_criterion)
      smart_criterion = create(:positive_criterion)

      user = create(:user_alpha)
      user.initialize_points_balance

      score = user.create_score(thing_type: 'twitter_handle', thing_value: 'grantmorrison')
      expect(user.user_points_total.amount).to eq(1000)
      expect(user.remaining_points).to eq(1000)

      user.add_or_change_subscore(score, funny_criterion, 40)
      expect(user.remaining_points).to eq(960)

      user.add_or_change_subscore(score, smart_criterion, 30)
      expect(user.remaining_points).to eq(930)

      user.add_or_change_subscore(score, funny_criterion, 38)
      expect(user.remaining_points).to eq(932)
    end

    it "should calculate the remaining points when the user has more than one score" do
      funny_criterion = create(:positive_criterion)
      smart_criterion = create(:positive_criterion)

      user = create(:user_alpha)
      user.initialize_points_balance

      grant_score = user.create_score(thing_type: 'twitter_handle', thing_value: 'grantmorrison')
      cbgirl_score = user.create_score(thing_type: 'twitter_handle', thing_value: 'cbgirl19')
      expect(user.user_points_total.amount).to eq(1000)
      expect(user.remaining_points).to eq(1000)

      user.add_or_change_subscore(grant_score, funny_criterion, 40)
      expect(user.remaining_points).to eq(960)

      user.add_or_change_subscore(cbgirl_score, smart_criterion, 30)
      expect(user.remaining_points).to eq(930)

      user.add_or_change_subscore(grant_score, funny_criterion, 38)
      expect(user.remaining_points).to eq(932)

      user.add_or_change_subscore(cbgirl_score, funny_criterion, 80)
      expect(user.remaining_points).to eq(852)
    end

    it "should calculate the remaining points after the user points total amount has changed" do
      funny_criterion = create(:positive_criterion)
      smart_criterion = create(:positive_criterion)

      user = create(:user_alpha)
      user.initialize_points_balance

      expect(user.user_points_total.amount).to eq(1000)

      score = user.create_score(thing_type: 'twitter_handle', thing_value: 'grantmorrison')
      expect(user.user_points_total.amount).to eq(1000)
      expect(user.remaining_points).to eq(1000)

      user.add_or_change_subscore(score, funny_criterion, 40)
      user.add_or_change_subscore(score, smart_criterion, 70)
      expect(user.user_points_total.amount).to eq(1000)
      expect(user.remaining_points).to eq(890)

      # increase the user's points total, should increase change remaining points calculation
      User.increase_user_points_total(user, 200)
      expect(user.user_points_total.amount).to eq(1200)
      expect(user.remaining_points).to eq(1090)
    end
  end

  describe "restricting adding or changing scores based on insufficient remaining points" do
    it "should stop the user from changing an existing subscore's value when user has insufficient remaining points" do
      funny_criterion = create(:positive_criterion)
      smart_criterion = create(:positive_criterion)

      user = create(:user_alpha)
      user.initialize_points_balance

      score = user.create_score(thing_type: 'twitter_handle', thing_value: 'grantmorrison')
      expect(user.user_points_total.amount).to eq(1000)
      expect(user.remaining_points).to eq(1000)

      user.add_or_change_subscore(score, smart_criterion, 400)
      user.add_or_change_subscore(score, funny_criterion, 500)
      expect(score.subscores.where(criterion: smart_criterion).first.value).to eq(400)
      expect(score.subscores.where(criterion: funny_criterion).first.value).to eq(500)
      expect(user.remaining_points).to eq(100)

      # user already used 900 points, only has 100 remaining, can't change subscore for smart criterion from 400 to 501
      # because that would cause remaining points to be -1, less than zero
      expect{
        user.add_or_change_subscore(score, smart_criterion, 501)
      }.to raise_error(InsufficientPointsError)

      # user can change smart criterion subscore to increase it to 500, resulting in remaining points being zero
      expect(score.subscores.length).to eq(2)
      expect(score.subscores.where(criterion: smart_criterion).first.value).to eq(400)
      expect(score.subscores.where(criterion: funny_criterion).first.value).to eq(500)
      expect(user.remaining_points).to eq(100)
      user.add_or_change_subscore(score, smart_criterion, 450)
      expect(score.subscores.where(criterion: smart_criterion).first.value).to eq(450)
      expect(score.subscores.where(criterion: funny_criterion).first.value).to eq(500)
      expect(user.remaining_points).to eq(50)
    end

    it "should stop the user from adding a new subscore when user has insufficient remaining points" do
      funny_criterion = create(:positive_criterion)
      smart_criterion = create(:positive_criterion)

      user = create(:user_alpha)
      user.initialize_points_balance

      score = user.create_score(thing_type: 'twitter_handle', thing_value: 'grantmorrison')
      expect(user.user_points_total.amount).to eq(1000)
      expect(user.remaining_points).to eq(1000)

      user.add_or_change_subscore(score, smart_criterion, 950)
      expect(user.remaining_points).to eq(50)

      # user already used 950 points, only has 50 remaining, can't add subscore of 51, insufficient points
      expect{
        user.add_or_change_subscore(score, funny_criterion, 51)
      }.to raise_error(InsufficientPointsError) # you're done, funny man
    end

    it "should not stop the user from adding a new subscore after increasing the user's points total" do
      # TODO maybe this spec should be organized in another location?  more describes increasing points total, not raising error?
      funny_criterion = create(:positive_criterion)
      smart_criterion = create(:positive_criterion)

      user = create(:user_alpha)
      user.initialize_points_balance

      score = user.create_score(thing_type: 'twitter_handle', thing_value: 'grantmorrison')
      expect(user.user_points_total.amount).to eq(1000)
      expect(user.remaining_points).to eq(1000)

      user.add_or_change_subscore(score, smart_criterion, 950)
      expect(user.remaining_points).to eq(50)

      # user already used 950 points, only has 50 remaining, can't add subscore of 51, insufficient points
      expect{
        user.add_or_change_subscore(score, funny_criterion, 51)
      }.to raise_error(InsufficientPointsError)

      # increasing user points total by 1 should now allow the user to add a subscore of 51
      # without raising an error for insufficient points
      User.increase_user_points_total(user, 1)
      expect(user.remaining_points).to eq(51)
      user.add_or_change_subscore(score, funny_criterion, 51)
    end
  end
end