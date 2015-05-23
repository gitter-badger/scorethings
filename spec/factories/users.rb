FactoryGirl.define do
  sequence(:user_description) { |n| "User Description #{n}" }

  factory :user_alpha, class: User do
    username 'manuisfunny'
    description { FactoryGirl.generate(:user_description) }
  end

  factory :user_bravo, class: User do
    username 'bravo'
    description { FactoryGirl.generate(:user_description) }
  end
end