require 'rails_helper'

RSpec.describe User do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)
  before do
    @user = build(:user_alpha)
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

      score = @user.create_score(thing_type: 'TWITTER_UID', thing_value: '99999')
      positive_criterion = create(:positive_criterion)

      expect(score.subscores.length).to eq(1)
      @user.add_or_change_subscore(score, positive_criterion, 50)
      expect(score.subscores.length).to eq(2)

      @user.add_or_change_subscore(score, positive_criterion, 20)
      expect(score.subscores.length).to eq(2)
    end

    it "should change the value of a subscore in a score with two subscores" do

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