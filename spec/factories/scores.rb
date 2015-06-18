FactoryGirl.define do
  factory :score, class: Score do |s|
    s.points 75
    s.thing { FactoryGirl.create(:thing) }
  end
end