FactoryGirl.define do
  factory :score, class: Score do |s|
    s.points 75
    s.good 70
    s.thing_reference { FactoryGirl.create(:thing_reference, :twitter_account) }
  end
end