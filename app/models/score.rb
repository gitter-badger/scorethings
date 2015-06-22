class Score
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  include Mongoid::Token

  field :points, type: Integer

  belongs_to :user
  belongs_to :thing

  search_in thing: [:title, :description]

  token :contains => :fixed_numeric, :length => 8

  validates_numericality_of :points, greater_than_or_equal_to: 1, less_than_or_equal_to: 100, only_integer: true
  validates_presence_of :thing, :user, :points
end