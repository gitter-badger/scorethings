FactoryGirl.define do
  sequence(:twitter_account_display_value) { |n| "SomeTwitterUser_#{n}" }
  sequence(:twitter_account_external_id) { |n| "10000#{n}" }
  sequence(:youtube_video_external_id) { |n| "99000#{n}" }
  sequence(:youtube_video_display_value) { |n| "Another cat video ##{n}" }
  sequence(:hashtag_display_value) { |n| "#SomeHashtag#{n}" }

  factory :twitter_account_thing, class: Thing do |t|
    t.type Scorething::ThingTypes::TWITTER_ACCOUNT
    t.external_id { FactoryGirl.generate(:twitter_account_external_id) }
    t.display_value { FactoryGirl.generate(:twitter_account_display_value) }
  end

  factory :youtube_video_thing, class: Thing do |t|
    t.type Scorething::ThingTypes::YOUTUBE_VIDEO
    t.external_id { FactoryGirl.generate(:youtube_video_external_id) }
    t.display_value { FactoryGirl.generate(:youtube_video_display_value) }
  end

  factory :hashtag_thing, class: Thing do |t|
    t.type Scorething::ThingTypes::HASHTAG
    t.external_id nil
    t.display_value { FactoryGirl.generate(:hashtag_display_value) }
  end
end