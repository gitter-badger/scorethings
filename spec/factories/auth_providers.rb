FactoryGirl.define do
  sequence(:auth_provider_handle) { |n| "handle_##{n}" }
  sequence(:auth_provider_uid) { |n| "1000##{n}" }

  factory :twitter_auth_provider, class: AuthProvider do |a|
    a.uid { FactoryGirl.generate(:auth_provider_uid) }
    a.handle { FactoryGirl.generate(:auth_provider_handle) }
    a.type 'twitter'
  end
end