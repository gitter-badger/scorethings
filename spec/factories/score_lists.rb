FactoryGirl.define do
  sequence(:score_list_name) { |n| "Score List ##{n}" }

  factory :score_list, class: ScoreList do |s|
    s.name { FactoryGirl.generate(:score_list_name) }
  end
end