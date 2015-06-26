class Score
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  include Mongoid::Token

  field :points, type: Integer

  belongs_to :criterion

  belongs_to :user
  belongs_to :thing

  embeds_many :old_points

  search_in thing: [:title, :description, :instance_of_values], user: [:username], criterion: [:title]

  token :contains => :fixed_numeric, :length => 8

  validates_numericality_of :points, greater_than_or_equal_to: 0, less_than_or_equal_to: 10, only_integer: true
  validates_presence_of :thing, :user, :points



  def update_points(points)
    old_points = self.points
    self.points = points
    self.save!

    if self.old_points.length < 1
      started_at = self.created_at
    else
      started_at = self.old_points.last.ended_at
    end
    ended_at = Time.new

    self.old_points << OldPoints.new(points: old_points, started_at: started_at, ended_at: ended_at)
  end
end