FactoryGirl.define do
  sequence(:name) { |n| "Criterion #{n}" }

  factory :positive_criterion, class: Criterion do
    name
    definition 'A positive criterion used in spec tests'
    type 1
  end

  factory :negative_criterion, class: Criterion do
    name
    definition 'A negative criterion used in spec tests'
    type -1
  end
end