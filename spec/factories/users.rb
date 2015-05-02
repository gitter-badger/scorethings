FactoryGirl.define do
  factory :manu, class: User do
    twitterHandle 'manuisfunny'
    twitterUid '1234'
  end

  factory :tony, class: User do
    twitterHandle 'tonymase83'
    twitterUid '8888'
  end
end