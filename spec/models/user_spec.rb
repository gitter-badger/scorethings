require 'rails_helper'

RSpec.describe User do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)

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

  # TODO use mongoid-rspec gem to test model validation
  xit "should not create an empty score for an unsupported subject type" do
    patton = build(:pattonoswalt)
    expect(patton.create_score(subject_type: 'twitter_whatever', subject_value: 'whatitdo')).to raise_error(Mongoid::Errors::Validations)
  end
end