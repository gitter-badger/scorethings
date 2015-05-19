FactoryGirl.define do
  factory :score, class: Score do |s|
    s.points 50
    s.thing { FactoryGirl.build(:twitter_account_thing) }
    s.score_category { FactoryGirl.create(:score_category) }
  end
end