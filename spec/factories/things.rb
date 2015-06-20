FactoryGirl.define do
  sequence(:thing_title) { |n| "Patton Oswalt Thing #{n}" }
  sequence(:thing_full_url) { |n| "https://en.wikipedia.org/wiki/Patton_Oswalt_Thing_#{n}" }
  sequence(:thing_pageid) { |n| 1000 + n }

  factory :thing, class: Thing do |t|
    t.title { FactoryGirl.generate(:thing_title) }
    t.full_url { FactoryGirl.generate(:thing_full_url) }
    t.pageid { FactoryGirl.generate(:thing_pageid) }
  end
end