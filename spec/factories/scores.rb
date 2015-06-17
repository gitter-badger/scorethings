FactoryGirl.define do
  factory :score, class: Score do |s|
    s.points 75
    s.thing { FactoryGirl.create(:thing_reference, :twitter_account) }
  end
end