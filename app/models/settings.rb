class Settings
  include Mongoid::Document

  field :default_points, type: Integer, default: 80
  field :default_good_point, type: Integer, default: 65

  embedded_in :user

  validates_presence_of :default_points, :default_good_point
  validates_numericality_of :default_points, greater_than_or_equal_to: 1, less_than_or_equal_to: 100, only_integer: true
  validates_numericality_of :default_good_point, greater_than_or_equal_to: 2, less_than_or_equal_to: 99, only_integer: true
end
