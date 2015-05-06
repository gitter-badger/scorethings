class Criterion
  include Mongoid::Document
  field :name, type: String
  field :sign, type: Integer, default: 1
  field :definition, type: String, default: 'no criterion definition provided'
  field :system_provided, type: Boolean, default: false
  field :is_user_default, type: Boolean, default: false
  belongs_to :user

  embeds_many :criterion_levels, order: :level_number.asc

  validates_presence_of :name, :sign, :system_provided

  MAX_CRITERION_LEVELS = 10

  def add_level(name, level_number=nil)
    if level_number.nil?
      level_number = self.criterion_levels.length + 1
    end

    if level_number > MAX_CRITERION_LEVELS
      raise TooManyCriterionLevelsError, "could not add criterion level, only #{MAX_CRITERION_LEVELS} are allowed"
    end

    if level_number < self.criterion_levels.length
      self.criterion_levels.each do |criterion_level|
        if criterion_level.level_number >= level_number
          criterion_level.level_number = criterion_level.level_number + 1
        end
      end
    end
    self.criterion_levels << CriterionLevel.new(level_number: level_number, name: name)
    determine_level_ranges
  end

  def remove_level(level_number)
    criterion_level_to_remove = self.criterion_levels.where(level_number: level_number).first
    criterion_level_to_remove.destroy
    determine_level_ranges
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

  private
  def determine_level_ranges
    # FIXME I know this looks bad, but I'm not smart enough to come up with a better solution right now
    # I just want to get this done so I can take a break and watch Community

    total_num_of_levels = self.criterion_levels.length
    return if total_num_of_levels == 0

    if total_num_of_levels == 1
      self.criterion_levels[0].floor = 1
      self.criterion_levels[0].ceiling = 100
      return
    end

    max_points = 100

    points_level_range_span = max_points / total_num_of_levels

    levels_in_order = self.criterion_levels.order(:level_number.asc)
    (1..total_num_of_levels).each do |level|
      floor = ((level - 1) * points_level_range_span) + 1
      ceiling = level * points_level_range_span
      if level == total_num_of_levels && (ceiling < max_points)
        ceiling = max_points
      end

      levels_in_order[level-1].level_number = level
      levels_in_order[level-1].floor = floor
      levels_in_order[level-1].ceiling = ceiling
      puts "level: #{level}, floor: #{floor}, ceiling: #{ceiling}"
    end

    self.criterion_levels.order(:level_number.asc).each do |cl|
      puts "level: #{cl.level_number}\tfloor: #{cl.floor}\tceiling: #{cl.ceiling}"
    end
  end

end