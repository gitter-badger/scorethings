FactoryGirl.define do
  sequence(:category_name) { |n| "ScoreCategory #{n}" }

  factory :score_category, class: ScoreCategory do |c|
    c.name { FactoryGirl.generate(:category_name) }
    c.description 'It do what it do'
  end
end