class Score
  include Mongoid::Document
  include Mongoid::Timestamps

  field :points, type: Integer, default: 0

  belongs_to :user
  embeds_one :thing
  embeds_many :score_categories

  validates_numericality_of :points, greater_than_or_equal_to: 0, less_than_or_equal_to: 100

  def to_builder
    Jbuilder.new do |score|
      score.user self.user.to_builder
      score.thing self.thing.to_builder
      score.points self.points
    end
  end

  def add_score_category(score_category)
    self.score_categories.each do |existing_score_category|
      if existing_score_category.category == score_category.category
        raise ScoreCategoryRedundancyError
      end
    end
    self.score_categories << score_category
    self.recalculate_points
  end

  def change_points(new_points)
    unless new_points == self.points
      self.points = new_points
      self.score_categories.delete_all
    end
  end

  def recalculate_points
    unless self.score_categories.length == 0
      total_points = 0
      self.score_categories.each do |score_category|
        total_points += score_category.points
      end
      self.points = (total_points / self.score_categories.length.to_f).round
    end
  end
end