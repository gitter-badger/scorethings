FactoryGirl.define do
  sequence(:twitter_uid_thing) { |n| Thing.new(value: "SomeTwitterUser_#{n}", type: 'TWITTER_UID') }
  sequence(:twitter_hashtag_thing) { |n| Thing.new(value: "SomeTwitterHashtag_#{n}", type: 'TWITTER_HASHTAG') }

  factory :twitter_uid_score, class: Score do |s|
    s.thing FactoryGirl.generate(:twitter_uid_thing)
  end

  factory :twitter_hashtag_score, class: Score do |s|
    s.thing FactoryGirl.generate(:twitter_hashtag_thing)
  end
end
