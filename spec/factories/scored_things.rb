FactoryGirl.define do
  sequence(:scored_thing_title) { |n| "Patton Oswalt Thing #{n}" }
  sequence(:scored_thing_thing_id) { |n| "Q#{n}00000" }
  sequence(:scored_thing_description) { |n| "Some cool Patton stuff about whatever #{n}" }

  factory :scored_thing, class: ScoredThing do |t|
    t.title { FactoryGirl.generate(:scored_thing_title) }
    t.thing_id { FactoryGirl.generate(:scored_thing_thing_id) }
    t.description { FactoryGirl.generate(:scored_thing_description) }
  end
end