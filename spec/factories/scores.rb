FactoryGirl.define do
  factory :twitter_uid_score, class: Score do |s|
    s.thing { FactoryGirl.build(:twitter_uid_thing) }
  end

  factory :twitter_hashtag_score, class: Score do |s|
    s.thing { FactoryGirl.build(:twitter_hashtag_thing) }
  end
end
