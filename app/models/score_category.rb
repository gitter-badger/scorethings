class ScoreCategory
  include Mongoid::Document
  include Mongoid::Timestamps

  field :points, type: Integer

  belongs_to :category
  embedded_in :score

  validates_numericality_of :points, greater_than_or_equal_to: 1, less_than_or_equal_to: 100

  def to_builder
    Jbuilder.new do |score|
      score.category self.category.to_builder
      score.points self.points
    end
  end
end
