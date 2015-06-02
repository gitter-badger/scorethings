FactoryGirl.define do
  factory :score, class: Score do |s|
    s.points 50
    s.thing { FactoryGirl.create(:thing, :twitter_account) }
  end
end