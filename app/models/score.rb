class Score
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  include Mongoid::Token

  field :points, type: Integer, default: 75

  belongs_to :user
  belongs_to :thing

  token :contains => :fixed_numeric, :length => 8
  search_in :thing => [:description, :title]

  validates_numericality_of :points, greater_than_or_equal_to: 1, less_than_or_equal_to: 100, only_integer: true
  validates_presence_of :thing
  validates_presence_of :user

  def to_builder
    Jbuilder.new do |score|
      score.id self.id
      score.token self.token
      score.user self.user.to_builder
      score.thing self.thing.to_builder
      score.points self.points
    end
  end
end