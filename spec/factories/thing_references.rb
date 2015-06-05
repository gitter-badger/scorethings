FactoryGirl.define do
  sequence(:thing_external_id) { |n| "10000#{n}" }
  sequence(:thing_hashtag_external_id) { |n| "SomeHashtagAboutCats#{n}" }

  factory :thing_reference, class: ThingReference do
    external_id { FactoryGirl.generate(:thing_external_id) }
    type Scorethings::ThingTypes::TWITTER_ACCOUNT

    trait :twitter_account do
      type Scorethings::ThingTypes::TWITTER_ACCOUNT
    end

    trait :github_repository do
      type Scorethings::ThingTypes::GITHUB_REPOSITORY
    end

    trait :hashtag do |h|
      h.type Scorethings::ThingTypes::HASHTAG
      h.external_id {FactoryGirl.generate(:thing_hashtag_external_id)}
    end
  end
end