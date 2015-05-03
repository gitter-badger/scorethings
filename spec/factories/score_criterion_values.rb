FactoryGirl.define do
  factory :positive_score_criterion_value, class: ScoreCriterionValue do |t|
    t.criterion FactoryGirl.build(:positive_criterion)
  end

  factory :negative_score_criterion_value, class: ScoreCriterionValue do |t|
    t.criterion FactoryGirl.build(:negative_criterion)
  end
end
