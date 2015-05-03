FactoryGirl.define do
  factory :twitter_handle_score, class: Score do
    sequence(:thing) { |n| Thing.new(value: "SomeTwitterUser_#{n}", type: 'twitter_handle') }
  end

  factory :twitter_hashtag_score, class: Score do
    sequence(:thing) { |n| Thing.new(value: "SomeTwitterSomethingOrAnother_#{n}", type: 'twitter_hashtag') }
  end
end
