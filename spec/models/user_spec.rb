require 'rails_helper'

RSpec.describe User do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)

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
    it "should add two positive score criteria values to a score" do
      patton = create(:pattonoswalt)

      score = patton.create_score(subject_type: 'twitter_handle', subject_value: 'grantmorrison')
      positive_criterion_1 = create(:positive_criterion)
      positive_criterion_2 = create(:positive_criterion)

      expect(score.score_criterion_values.length).to eq(0)
      patton.add_score_criterion_value(score, positive_criterion_1, 65)
      patton.add_score_criterion_value(score, positive_criterion_2, 52)
      expect(score.score_criterion_values.length).to eq(2)
      expect(score.calculate_total_score).to eq(117)
    end

    it "should add two positive and negative score criteria values to a score" do
      patton = create(:pattonoswalt)

      score = patton.create_score(subject_type: 'twitter_handle', subject_value: 'grantmorrison')
      positive_criterion = create(:positive_criterion)
      negative_criterion = create(:negative_criterion)

      expect(score.score_criterion_values.length).to eq(0)
      patton.add_score_criterion_value(score, positive_criterion, 65)
      patton.add_score_criterion_value(score, negative_criterion, 52)
      expect(score.score_criterion_values.length).to eq(2)
      expect(score.calculate_total_score).to eq(13)
    end

    it "should not allow adding two score criteria values with the same criterion" do
      patton = create(:pattonoswalt)

      score = patton.create_score(subject_type: 'twitter_handle', subject_value: 'grantmorrison')
      positive_criterion = create(:positive_criterion)

      patton.add_score_criterion_value(score, positive_criterion, 65)
      expect{ patton.add_score_criterion_value(score, positive_criterion, 52) }.to raise_error(RuntimeError)
    end
  end
end