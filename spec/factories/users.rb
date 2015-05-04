FactoryGirl.define do
  factory :user_alpha, class: User do
    twitter_handle 'manuisfunny'
    twitter_uid '1234'
  end

  factory :user_bravo, class: User do
    twitter_handle 'bravo'
    twitter_uid '8888'
  end
end