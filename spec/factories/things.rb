FactoryGirl.define do
  sequence(:twitter_uid_value) { |n| "SomeTwitterUser_#{n}" }
  sequence(:twitter_hashtag_value) { |n| "SomeTwitterHashtag_#{n}" }

  factory :twitter_uid_thing, class: Thing do |t|
    t.type 'TWITTER_UID'
    t.value { FactoryGirl.generate(:twitter_uid_value) }
  end

  factory :twitter_hashtag_thing, class: Thing do |t|
    t.type 'TWITTER_HASHTAG'
    t.value { FactoryGirl.generate(:twitter_hashtag_value) }
  end

  factory :thing, class: Thing do |t|
    t.type 'TWITTER_HASHTAG'
    t.value { FactoryGirl.generate(:twitter_hashtag_value) }
  end
end