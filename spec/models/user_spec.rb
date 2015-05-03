require 'rails_helper'

RSpec.describe User do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)

  describe "creating a new user with oauth" do
    it "should create a new user account with defaults" do
      # there are 4 criterion, so the new user should have
      # 4 user_criterion_score_balances
      positive_criterion = create(:positive_criterion)
      negative_criterion = create(:negative_criterion)

      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:twitter] = {
          provider: 'twitter',
          uid: '2121',
          info: OmniAuth::AuthHash::InfoHash.new({
              nickname: 'pattonoswalt'
          })
      }
      auth = OmniAuth.config.mock_auth[:twitter]
      patton = User.create_with_omniauth(auth)


      expect(patton.twitter_uid).to eq('2121')
      expect(patton.twitter_handle).to eq('pattonoswalt')
      expect(patton.scores.length).to eq(0)
      expect(patton.user_criterion_score_balances.length).to eq(2)

      # there should be 2 user_criterion_score_balances, one for each of the existing criteria
      # each one should have a remaining balance of 1000
      first_score_balance = patton.user_criterion_score_balances.where(criterion: positive_criterion._id).first
      expect(first_score_balance).to_not be_nil
      expect(first_score_balance.remaining_balance).to eq(1000)

      second_score_balance = patton.user_criterion_score_balances.where(criterion: negative_criterion._id).first
      expect(second_score_balance).to_not be_nil
      expect(second_score_balance.remaining_balance).to eq(1000)
    end
  end

  describe "creating scores" do
    it "should create an empty score for a subject that is a twitter handle" do
      patton = build(:pattonoswalt)

      expect(patton.scores.length).to eq(0)

      score = patton.create_score(subject_type: 'twitter_handle', subject_value: 'josswhedon')

      expect(score).to_not be_nil
      expect(score.user).to eq(patton)
      expect(score.score_subject).to_not be_nil
      expect(score.score_subject.type).to eq('twitter_handle')
      expect(score.score_subject.value).to eq('josswhedon')
      expect(score.calculate_total_score).to eq(0)

      expect(patton.scores.length).to eq(1)
    end

    it "should create an empty score for a subject that is a twitter hashtag" do
      patton = build(:pattonoswalt)

      expect(patton.scores.length).to eq(0)

      score = patton.create_score(subject_type: 'twitter_hashtag', subject_value: 'stelladoro')

      expect(score).to_not be_nil
      expect(score.user).to eq(patton)
      expect(score.score_subject).to_not be_nil
      expect(score.score_subject.type).to eq('twitter_hashtag')
      expect(score.score_subject.value).to eq('stelladoro')
      expect(score.calculate_total_score).to eq(0)

      expect(patton.scores.length).to eq(1)
    end

    it "should not create an empty score for an unsupported subject type" do
      patton = build(:pattonoswalt)
      expect{ patton.create_score(subject_type: 'twitter_whatever', subject_value: 'whatitdo') }.to raise_error(Mongoid::Errors::Validations)
    end
  end

  describe "adding score criteria values to a score" do
    it "should add two score criteria values to a score" do
      patton = create(:pattonoswalt)

      score = patton.create_score(subject_type: 'twitter_handle', subject_value: 'grantmorrison')
      positive_criterion_1 = create(:positive_criterion)
      positive_criterion_2 = create(:positive_criterion)

      expect(score.score_criterion_values.length).to eq(0)
      patton.add_score_criterion_value(score, positive_criterion_1, 65)
      patton.add_score_criterion_value(score, positive_criterion_2, 52)
      expect(score.score_criterion_values.length).to eq(2)

      # total calculation functionality is tested in score_spec
    end

    it "should not allow a score criterion value to be added without a criterion" do
      patton = create(:pattonoswalt)

      score = patton.create_score(subject_type: 'twitter_handle', subject_value: 'grantmorrison')
      expect{
        patton.add_score_criterion_value(score, nil, 65)
      }.to raise_error(ArgumentError)
    end

    it "should not allow a score criterion value to be added by a user who is not the score's user" do
      patton = create(:pattonoswalt)
      josswhedon = create(:josswhedon)
      negative_criterion = create(:negative_criterion)

      score = patton.create_score(subject_type: 'twitter_handle', subject_value: 'grantmorrison')
      expect{
        josswhedon.add_score_criterion_value(score, negative_criterion, 77)
      }.to raise_error(AccessDeniedError) # That's a dick move, Firefly.  Grant Morrison is legend.
    end
  end
end