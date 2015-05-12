FactoryGirl.define do
  sequence(:category_name) { |n| "Category #{n}" }

  factory :category, class: Category do |c|
    c.name { FactoryGirl.generate(:category_name) }
    c.description 'It do what it do'
  end
end