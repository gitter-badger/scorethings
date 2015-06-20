FactoryGirl.define do
  sequence(:thing_title) { |n| "Patton Oswalt Thing #{n}" }
  sequence(:thing_wikidata_item_id) { |n| "Q#{n}00000" }
  sequence(:thing_description) { |n| "Some cool Patton stuff about whatever #{n}" }

  factory :thing, class: Thing do |t|
    t.title { FactoryGirl.generate(:thing_title) }
    t.wikidata_item_id { FactoryGirl.generate(:thing_wikidata_item_id) }
    t.description { FactoryGirl.generate(:thing_description) }
  end
end