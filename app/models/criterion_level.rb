class CriterionLevel
  include Mongoid::Document
  field :name, type: String
  field :level_number, type: Integer
  field :ceiling, type: Integer
  field :floor, type: Integer
  embedded_in :criterion

  validates_presence_of :name, :level_number, :floor, :ceiling
  validates_numericality_of :level_number, greater_than_or_equal_to: 1, less_than_or_equal_to: 10
  validates_numericality_of :ceiling, greater_than_or_equal_to: 1, less_than_or_equal_to: 100
  validates_numericality_of :floor, greater_than_or_equal_to: 1, less_than_or_equal_to: 100

  def matches(points)
    (self.floor <= points) && (self.ceiling >= points)
  end
end
