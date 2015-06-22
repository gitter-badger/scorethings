FactoryGirl.define do
  sequence(:user_username) { |n| "user_#{n}" }

  factory :user, class: User do
    username { FactoryGirl.generate(:user_username) }
  end
end