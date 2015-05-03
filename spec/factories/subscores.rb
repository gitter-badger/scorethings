FactoryGirl.define do
  factory :positive_subscore, class: Subscore do |t|
    t.criterion FactoryGirl.build(:positive_criterion)
  end

  factory :negative_subscore, class: Subscore do |t|
    t.criterion FactoryGirl.build(:negative_criterion)
  end
end
