FactoryGirl.define do
  factory :score, class: Score do |s|
    s.points 7
    s.scored_thing { FactoryGirl.create(:scored_thing) }
    s.criterion { FactoryGirl.create(:criterion) }
  end
end