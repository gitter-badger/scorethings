FactoryGirl.define do
  sequence(:criterion_name) { |n| "Criterion #{n}" }

  factory :positive_criterion, class: Criterion do |t|
    t.name { FactoryGirl.generate(:criterion_name) }
    t.definition 'A positive criterion used in spec tests'
    t.sign 1
  end

  factory :negative_criterion, class: Criterion do |t|
    t.name { FactoryGirl.generate(:criterion_name) }
    t.definition 'A negative criterion used in spec tests'
    t.sign -1
  end
end