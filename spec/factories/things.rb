FactoryGirl.define do
  sequence(:thing_resource_name) { |n| "Some_Thing_#{n}" }
  sequence(:thing_label) { |n| "Some Thing #{n}" }
  sequence(:thing_description) { |n| "An interesting thing about Some Thing #{n}..." }

  factory :thing, class: Thing do |t|
    t.label { FactoryGirl.generate(:thing_label) }
    t.resource_name { FactoryGirl.generate(:thing_resource_name) }
    t.description { FactoryGirl.generate(:thing_description) }
  end
end