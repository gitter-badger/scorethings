FactoryGirl.define do
  sequence(:thing_categories_resource_name) { |n| "Some_Thing_Category_#{n}" }
  sequence(:thing_categories_label) { |n| "Some Thing Category #{n}" }

  factory :thing_category, class: ThingCategory do |t|
    t.label { FactoryGirl.generate(:thing_categories_label) }
    t.resource_name { FactoryGirl.generate(:thing_categories_resource_name) }
  end
end