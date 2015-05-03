FactoryGirl.define do
  factory :twitter_handle_score, class: Score do
    sequence(:score_subject) { |n| ScoreSubject.new(value: "SomeTwitterUser_#{n}", type: 'twitter_handle') }
  end

  factory :twitter_hashtag_score, class: Score do
    sequence(:score_subject) { |n| ScoreSubject.new(value: "SomeTwitterSomethingOrAnother_#{n}", type: 'twitter_hashtag') }
  end
end
