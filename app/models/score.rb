class Score
  include Mongoid::Document
  include Mongoid::Timestamps

  field :points, type: Integer, default: 0

  belongs_to :user
  belongs_to :category
  embeds_one :thing

  validates_numericality_of :points, greater_than_or_equal_to: 0, less_than_or_equal_to: 100, only_integer: true

  def to_builder
    Jbuilder.new do |score|
      score.user self.user.to_builder
      score.thing self.thing.to_builder
      score.points self.points
    end
  end
end