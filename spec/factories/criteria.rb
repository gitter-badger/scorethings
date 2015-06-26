FactoryGirl.define do
  sequence(:criterion_name) { |n| "Criterion #{n}" }

  factory :criterion, class: Criterion do |c|
    c.name { FactoryGirl.generate(:criterion_name) }
  end
end