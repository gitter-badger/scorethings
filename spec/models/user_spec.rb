require 'rails_helper'

RSpec.describe User do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)
  before do
    @user = build(:user_alpha)
    @user.initialize_points_balance
  end

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
          info: OmniAuth::AuthHash::InfoHash.new(nickname: 'alpha')
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

    describe "creating a user's general criterion when creating a score" do
      it "should create a user's general criterion when a score is created" do
        expect(@user.criteria.length).to eq(0)

        @user.create_score(thing_type: 'TWITTER_UID', thing_value: '99999')
        expect(@user.criteria.length).to eq(1)
        expect(@user.criteria.first.is_general).to eq(true)
      end

      it "should not create another general criterion the second time a score is created" do
        expect(@user.criteria.length).to eq(0)

        @user.create_score(thing_type: 'TWITTER_UID', thing_value: '99999')
        expect(@user.criteria.length).to eq(1)
        expect(@user.criteria.first.is_general).to eq(true)

        @user.create_score(thing_type: 'TWITTER_UID', thing_value: '10101')
        expect(@user.criteria.length).to eq(1)
        expect(@user.criteria.first.is_general).to eq(true)
      end
    end

    it "should create a score with a single, general criterion subscore for a subject that is a twitter handle" do
      expect(@user.scores.length).to eq(0)

      score = @user.create_score(thing_type: 'TWITTER_UID', thing_value: '99999')

      expect(score).to_not be_nil
      expect(score.user).to eq(@user)
      expect(score.thing).to_not be_nil
      expect(score.thing.type).to eq('TWITTER_UID')
      expect(score.thing.value).to eq('99999')
      expect(score.calculate_total_score).to eq(0)
      expect(score.subscores.length).to eq(1)

      expect(@user.scores.length).to eq(1)
    end

    it "should create a score with a single, general criterion subscore for a subject that is a twitter hashtag" do
      expect(@user.scores.length).to eq(0)

      score = @user.create_score(thing_type: 'TWITTER_HASHTAG', thing_value: 'stelladoro')

      expect(score).to_not be_nil
      expect(score.user).to eq(@user)
      expect(score.subscores.length).to eq(1)
      expect(score.thing).to_not be_nil
      expect(score.thing.type).to eq('TWITTER_HASHTAG')
      expect(score.thing.value).to eq('stelladoro')
      expect(score.calculate_total_score).to eq(0)

      expect(@user.scores.length).to eq(1)
    end

    it "should not create an score for an unsupported subject type" do
      expect{
        @user.create_score(thing_type: 'TWITTER_WHATEVER', thing_value: 'whatitdo')
      }.to raise_error(Mongoid::Errors::Validations)
    end
  end

  describe "adding subscores to a score" do
    it "should add two subscores to a score" do
      @user.initialize_points_balance

      score = @user.create_score(thing_type: 'TWITTER_UID', thing_value: '99999')
      positive_criterion_1 = create(:positive_criterion)
      positive_criterion_2 = create(:positive_criterion)

      expect(score.subscores.length).to eq(1)
      @user.add_or_change_subscore(score, positive_criterion_1, 65)
      @user.add_or_change_subscore(score, positive_criterion_2, 52)
      expect(score.subscores.length).to eq(3)
      score.reload
      expect(score.subscores.length).to eq(3)
    end

    it "should not allow a subscore to be added without a criterion" do
      score = @user.create_score(thing_type: 'TWITTER_UID', thing_value: '99999')
      expect{
        @user.add_or_change_subscore(score, nil, 65)
      }.to raise_error(ArgumentError)
    end

    it "should not allow a subscore to be added by a user who is not the score's user" do
      user_bravo = create(:user_bravo)
      negative_criterion = create(:negative_criterion)

      score = @user.create_score(thing_type: 'TWITTER_UID', thing_value: '99999')
      expect{
        user_bravo.add_or_change_subscore(score, negative_criterion, 77)
      }.to raise_error(AccessDeniedError)
    end
  end

  describe "changing an existing subscore value" do
    it "should change the value of a subscore in a score with one subscore" do
      @user.initialize_points_balance

      score = @user.create_score(thing_type: 'TWITTER_UID', thing_value: '99999')
      positive_criterion = create(:positive_criterion)

      expect(score.subscores.length).to eq(1)
      @user.add_or_change_subscore(score, positive_criterion, 50)
      expect(@user.user_points_total.amount).to eq(1000)
      expect(@user.remaining_points).to eq(950)
      expect(score.subscores.length).to eq(2)

      @user.add_or_change_subscore(score, positive_criterion, 20)
      expect(@user.user_points_total.amount).to eq(1000)
      expect(@user.remaining_points).to eq(980)
      expect(score.subscores.length).to eq(2)
    end

    it "should change the value of a subscore in a score with two subscores" do
      @user.initialize_points_balance

      score = @user.create_score(thing_type: 'TWITTER_UID', thing_value: '99999')
      positive_criterion_1 = create(:positive_criterion)
      positive_criterion_2 = create(:positive_criterion)

      expect(score.subscores.length).to eq(1)
      @user.add_or_change_subscore(score, positive_criterion_1, 50)
      @user.add_or_change_subscore(score, positive_criterion_2, 20)
      expect(score.subscores.length).to eq(3)
      expect(score.subscores.where(criterion: positive_criterion_1).first.value).to eq(50)
      expect(score.subscores.where(criterion: positive_criterion_2).first.value).to eq(20)

      @user.add_or_change_subscore(score, positive_criterion_1, 55)
      expect(score.subscores.where(criterion: positive_criterion_1).first.value).to eq(55)
      expect(score.subscores.where(criterion: positive_criterion_2).first.value).to eq(20)
    end
  end

  describe "calculating remaining points" do
    it "should calculate the remaining points when a subscore is added and changed" do
      funny_criterion = create(:positive_criterion)
      smart_criterion = create(:positive_criterion)

      @user.initialize_points_balance

      score = @user.create_score(thing_type: 'TWITTER_UID', thing_value: '99999')
      expect(@user.user_points_total.amount).to eq(1000)
      expect(@user.remaining_points).to eq(1000)

      @user.add_or_change_subscore(score, funny_criterion, 40)
      expect(@user.remaining_points).to eq(960)

      @user.add_or_change_subscore(score, smart_criterion, 30)
      expect(@user.remaining_points).to eq(930)

      @user.add_or_change_subscore(score, funny_criterion, 38)
      expect(@user.remaining_points).to eq(932)
    end

    it "should calculate the remaining points when the user has more than one score" do
      funny_criterion = create(:positive_criterion)
      smart_criterion = create(:positive_criterion)

      @user.initialize_points_balance

      grant_score = @user.create_score(thing_type: 'TWITTER_UID', thing_value: '99999')
      cbgirl_score = @user.create_score(thing_type: 'TWITTER_UID', thing_value: '33333')
      expect(@user.user_points_total.amount).to eq(1000)
      expect(@user.remaining_points).to eq(1000)

      @user.add_or_change_subscore(grant_score, funny_criterion, 40)
      expect(@user.remaining_points).to eq(960)

      @user.add_or_change_subscore(cbgirl_score, smart_criterion, 30)
      expect(@user.remaining_points).to eq(930)

      @user.add_or_change_subscore(grant_score, funny_criterion, 38)
      expect(@user.remaining_points).to eq(932)

      @user.add_or_change_subscore(cbgirl_score, funny_criterion, 80)
      expect(@user.remaining_points).to eq(852)
    end

    it "should calculate the remaining points after the user points total amount has changed" do
      funny_criterion = create(:positive_criterion)
      smart_criterion = create(:positive_criterion)

      @user.initialize_points_balance

      expect(@user.user_points_total.amount).to eq(1000)

      score = @user.create_score(thing_type: 'TWITTER_UID', thing_value: '99999')
      expect(@user.user_points_total.amount).to eq(1000)
      expect(@user.remaining_points).to eq(1000)

      @user.add_or_change_subscore(score, funny_criterion, 40)
      @user.add_or_change_subscore(score, smart_criterion, 70)
      expect(@user.user_points_total.amount).to eq(1000)
      expect(@user.remaining_points).to eq(890)

      # increase the user's points total, should increase change remaining points calculation
      User.increase_user_points_total(@user, 200)
      expect(@user.user_points_total.amount).to eq(1200)
      expect(@user.remaining_points).to eq(1090)
    end
  end

  describe "restricting adding or changing scores based on insufficient remaining points" do
    it "should stop the user from CHANGING an existing subscore's value when user has insufficient remaining points" do
      funny_criterion = create(:positive_criterion)
      smart_criterion = create(:positive_criterion)

      @user.initialize_points_balance

      score = @user.create_score(thing_type: 'TWITTER_UID', thing_value: '99999')
      expect(@user.user_points_total.amount).to eq(1000)
      expect(@user.remaining_points).to eq(1000)

      # use 990 points on subscore points
      create_list(:positive_criterion, 10).each do |criterion|
        @user.add_or_change_subscore(score, criterion, 99)
      end
      expect(@user.remaining_points).to eq(10)
      @user.add_or_change_subscore(score, funny_criterion, 9)
      expect(@user.remaining_points).to eq(1)

      # user already used 999 points, only has 1 remaining, can't change subscore for funny criterion from 400 to 501
      # because that would cause remaining points to be -1, less than zero
      expect{
        @user.add_or_change_subscore(score, funny_criterion, 11)
      }.to raise_error(InsufficientPointsError)

      # user can change smart criterion subscore to increase it to 500, resulting in remaining points being zero
      @user.add_or_change_subscore(score, funny_criterion, 10)
      expect(@user.remaining_points).to eq(0)
    end

    it "should stop the user from ADDING a new subscore when user has insufficient remaining points" do
      funny_criterion = create(:positive_criterion)

      @user.initialize_points_balance

      score = @user.create_score(thing_type: 'TWITTER_UID', thing_value: '99999')
      expect(@user.user_points_total.amount).to eq(1000)
      expect(@user.remaining_points).to eq(1000)

      create_list(:positive_criterion, 10).each do |criterion|
        @user.add_or_change_subscore(score, criterion, 95)
      end
      expect(@user.remaining_points).to eq(50)

      # user already used 950 points, only has 50 remaining, can't add subscore of 51, insufficient points
      expect{
        @user.add_or_change_subscore(score, funny_criterion, 51)
      }.to raise_error(InsufficientPointsError) # you're done, funny man
    end

    it "should not stop the user from adding a new subscore after increasing the user's points total" do
      # TODO maybe this spec should be organized in another location?  more describes increasing points total, not raising error?
      funny_criterion = create(:positive_criterion)

      @user.initialize_points_balance

      score = @user.create_score(thing_type: 'TWITTER_UID', thing_value: '99999')
      expect(@user.user_points_total.amount).to eq(1000)
      expect(@user.remaining_points).to eq(1000)

      create_list(:positive_criterion, 10).each do |criterion|
        @user.add_or_change_subscore(score, criterion, 95)
      end
      expect(@user.remaining_points).to eq(50)

      # user already used 950 points, only has 50 remaining, can't add subscore of 51, insufficient points
      expect{
        @user.add_or_change_subscore(score, funny_criterion, 51)
      }.to raise_error(InsufficientPointsError)

      # increasing user points total by 1 should now allow the user to add a subscore of 51
      # without raising an error for insufficient points
      User.increase_user_points_total(@user, 1)
      expect(@user.remaining_points).to eq(51)
      @user.add_or_change_subscore(score, funny_criterion, 51)
    end
  end

  describe "creating or finding a score for a twitter account" do
    it "should find a score of a twitter uid by the user" do
      @user.create_score(thing_type: 'TWITTER_HASHTAG', thing_value: 'SomeHashtag')
      created_twitter_uid_score = @user.create_score(thing_type: 'TWITTER_UID', thing_value: '99999')
      expect(@user.scores.length).to eq(2)
      found_score = @user.create_or_find_score_for_things(thing_type: 'TWITTER_UID', thing_value: '99999')
      expect(@user.scores.length).to eq(2)
      expect(found_score).to eq(created_twitter_uid_score)
    end

    it "should create a score of a twitter uid because it can't find a score created by the user" do
      @user.create_score(thing_type: 'TWITTER_HASHTAG', thing_value: 'SomeHashtag')
      @user.create_score(thing_type: 'TWITTER_UID', thing_value: '99999')
      expect(@user.scores.length).to eq(2)
      created_score = @user.create_or_find_score_for_things(thing_type: 'TWITTER_UID', thing_value: '11111')
      expect(@user.scores.length).to eq(3)
      expect(created_score.thing.type).to eq('TWITTER_UID')
      expect(created_score.thing.value).to eq('11111')
    end
  end

  describe "creating a criterion" do
    it "should be able to create a non system provided criterion with levels" do
      criteria = @user.create_criterion(name: "Alpha's Idea of Funny", definition: "Make me laugh, with the ha ha's.")
      expect(criteria).to_not be_nil
      expect(criteria.user).to eq(@user)
      expect(criteria.system_provided).to eq(false)
    end

    it "should be not be able to create a criterion and say it is system provided" do
      # TODO should this instead be a raised app error?
      # or, assume the rails controller would not allow the attribute of system_provided ?
      criterion = @user.create_criterion(name: "Alpha's Idea of Funny", definition: "Make me laugh, with the ha ha's.", system_provided: true)
      expect(criterion).to_not be_nil
      expect(criterion.user).to eq(@user)
      expect(criterion.system_provided).to eq(false)
    end
  end
end