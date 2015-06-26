FactoryGirl.define do
  factory :score, class: Score do |s|
    s.points 7
    s.thing { FactoryGirl.create(:thing) }
    s.criterion { FactoryGirl.create(:criterion) }
  end
end