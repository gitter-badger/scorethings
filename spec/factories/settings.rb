FactoryGirl.define do
  factory :settings, class: Settings do |a|
    a.default_points 75
    a.default_good 60
  end
end