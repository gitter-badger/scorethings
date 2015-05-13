FactoryGirl.define do
  factory :twitter_uid_score, class: Score do |s|
    s.thing { FactoryGirl.build(:twitter_uid_thing) }
    s.category {FactoryGirl.create(:score_category)}
  end

  factory :twitter_hashtag_score, class: Score do |s|
    s.thing { FactoryGirl.build(:twitter_hashtag_thing) }
    s.category {FactoryGirl.create(:score_category)}
  end
end
