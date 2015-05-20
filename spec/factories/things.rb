FactoryGirl.define do
  sequence(:thing_title) { |n| "SomeTwitterUser_#{n}" }
  sequence(:thing_external_id) { |n| "10000#{n}" }
  sequence(:thing_image_uri) { |n| "http://image.url.com/9283#{n}.jpg" }
  sequence(:thing_uri) { |n| "http://resources.url.com/9283#{n}" }
  sequence(:thing_description) { |n| "Thing description #{n}" }

  factory :thing, class: Thing do
    title { FactoryGirl.generate(:thing_title) }
    external_id { FactoryGirl.generate(:thing_external_id) }
    image_uri { FactoryGirl.generate(:thing_image_uri) }
    uri { FactoryGirl.generate(:thing_uri) }
    description { FactoryGirl.generate(:thing_description) }

    trait :twitter_tweet do
      type Scorethings::ThingTypes::TWITTER_TWEET
    end

    trait :twitter_account do
      type Scorethings::ThingTypes::TWITTER_ACCOUNT
    end

    trait :youtube_video do
      type Scorethings::ThingTypes::YOUTUBE_VIDEO
    end

    trait :hashtag do
      type Scorethings::ThingTypes::HASHTAG
      external_id nil
      image_uri nil
      uri nil
      description nil
    end
  end
end