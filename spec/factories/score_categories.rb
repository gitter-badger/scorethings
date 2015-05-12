FactoryGirl.define do
  factory :score_category, class: ScoreCategory do |s|
    s.category {FactoryGirl.create(:category)}
  end
end