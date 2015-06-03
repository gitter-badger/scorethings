FactoryGirl.define do
  factory :score, class: Score do |s|
    s.points 75
    s.meh_floor 60
    s.meh_ceiling 75
    s.thing { FactoryGirl.create(:thing, :twitter_account) }
  end
end