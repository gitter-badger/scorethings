FactoryGirl.define do
  sequence(:thing_hashtag_dbpedia_uri) { |n| "http://dbpedia.org/resource/Batman_#{n}" }

  factory :thing_reference, class: Thing do
    dbpedia_uri { FactoryGirl.generate(:thing_dbpedia_uri) }
    type Scorethings::ThingTypes::TWITTER_ACCOUNT
  end
end