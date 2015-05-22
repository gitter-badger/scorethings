FactoryGirl.define do
  sequence(:score_category_name) { |n| "ScoreCategory #{n}" }
  sequence(:score_category_description) { |n| "Description ##{n} of a Score Category" }

  factory :score_category, class: ScoreCategory do |c|
    c.name { FactoryGirl.generate(:score_category_name) }
    c.description { FactoryGirl.generate(:score_category_description) }
  end
end