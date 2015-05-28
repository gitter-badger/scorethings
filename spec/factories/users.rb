FactoryGirl.define do
  sequence(:user_username) { |n| "user_#{n}" }
  sequence(:user_description) { |n| "User Description #{n}" }

  factory :user_alpha, class: User do
    username { FactoryGirl.generate(:user_username) }
    description { FactoryGirl.generate(:user_description) }
  end

  factory :user_bravo, class: User do
    username { FactoryGirl.generate(:user_username) }
    description { FactoryGirl.generate(:user_description) }
  end
end