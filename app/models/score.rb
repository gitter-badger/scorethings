class Score
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  include Mongoid::Token

  field :points, type: Integer
  field :good, type: Integer

  belongs_to :user
  belongs_to :thing_reference

  token :contains => :fixed_numeric, :length => 8

  validates_numericality_of :points, greater_than_or_equal_to: 1, less_than_or_equal_to: 100, only_integer: true
  validates_numericality_of :good, greater_than_or_equal_to: 2, less_than_or_equal_to: 99, only_integer: true
  validates_presence_of :thing_reference, :user, :points, :good

  def to_builder
    Jbuilder.new do |score|
      score.id self.id
      score.token self.token
      score.user self.user.to_builder
      score.thing_reference self.thing_reference.to_builder
      score.points self.points
      score.good self.good
    end
  end
end