class CriterionLevel
  include Mongoid::Document
  field :name, type: String
  field :level_number, type: Integer
  embedded_in :criterion

  validates_presence_of :name, :level_number
  validates_numericality_of :level_number, greater_than_or_equal_to: 1, less_than_or_equal_to: 10

  def matches(points)
    min = (self.level_number) * 10
    max = (self.level_number * 10) + 9
    is_match = (min <= points) && (max >= points)
    puts "points: (#{points}), min: (#{min}), max: (#{max}), is_match: #{is_match}"
    return is_match
  end
end
