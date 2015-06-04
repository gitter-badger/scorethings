FactoryGirl.define do
  factory :score, class: Score do |s|
    s.points 75
    s.good_point 70
    s.thing { FactoryGirl.create(:thing, :twitter_account) }
  end
end