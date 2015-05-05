class Criterion
  include Mongoid::Document
  field :name, type: String
  field :sign, type: Integer, default: 1
  field :definition, type: String, default: 'no criterion definition provided'
  field :system_provided, type: Boolean, default: false
  belongs_to :user

  embeds_many :criterion_levels, order: :level_number.asc

  validates_uniqueness_of :name
  validates_presence_of :name, :sign, :system_provided

  def add_level(level_number, name)
    self.criterion_levels << CriterionLevel.new(level_number: level_number, name: name)
  end

  def find_level_for_points(points)
    last_criterion_level = nil
    self.criterion_levels.order(:level_number.asc).each do |criterion_level|
      last_criterion_level = criterion_level
      if criterion_level.matches(points)
        return criterion_level
      end
    end
    return last_criterion_level
  end
end