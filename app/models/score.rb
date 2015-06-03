class Score
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  include Mongoid::Token

  field :points, type: Integer, default: 75
  field :meh_floor, type: Integer, default: 65
  field :meh_ceiling, type: Integer, default: 80

  embeds_many :score_archives

  belongs_to :user
  belongs_to :thing

  token :contains => :fixed_numeric, :length => 8
  search_in :thing => [:description, :title]

  validates_numericality_of :points, greater_than_or_equal_to: 1, less_than_or_equal_to: 100, only_integer: true
  validates_numericality_of :meh_floor, greater_than_or_equal_to: 1, less_than_or_equal_to: 100, only_integer: true
  validates_numericality_of :meh_ceiling, greater_than_or_equal_to: 1, less_than_or_equal_to: 100, only_integer: true
  validates_presence_of :thing
  validates_presence_of :user
  validates_presence_of :points
  validates_presence_of :meh_floor
  validates_presence_of :meh_ceiling

  def to_builder
    Jbuilder.new do |score|
      score.id self.id
      score.token self.token
      score.user self.user.to_builder
      score.thing self.thing.to_builder
      score.points self.points
    end
  end

  def update(attrs)
    old_meh_floor = self.meh_floor
    old_meh_ceiling = self.meh_ceiling
    old_points = self.points

    self.meh_floor = attrs[:meh_floor] unless attrs[:meh_floor].nil?
    self.meh_ceiling = attrs[:meh_ceiling] unless attrs[:meh_ceiling].nil?

    unless attrs[:points].nil? || attrs[:points] == self.points
      self.points = attrs[:points]
      self.update!
      self.score_archives << ScoreArchive.new(points: old_points,
                                                meh_floor: old_meh_floor,
                                                meh_ceiling: old_meh_ceiling)
    end
  end
end