FactoryGirl.define do
  sequence(:thing_category_title) { |n| "Category:Some Thing #{n}" }

  factory :thing_category, class: ThingCategory do |t|
    t.title { FactoryGirl.generate(:thing_category_title) }
  end
end