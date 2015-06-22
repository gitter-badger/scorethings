class Score
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  include Mongoid::Token

  field :points, type: Integer
  field :criterion, type: String, default: 'General'

  belongs_to :user
  belongs_to :thing

  embeds_many :old_points

  search_in thing: [:title, :description]

  token :contains => :fixed_numeric, :length => 8

  validates_numericality_of :points, greater_than_or_equal_to: 1, less_than_or_equal_to: 100, only_integer: true
  validates_presence_of :thing, :user, :points
  validates_inclusion_of :criterion, in: %w(Funny Intelligent Brave Unique Important Fast Kind Honest Beautiful Awesome Delicious General)

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

  def self.valid_criteria
    [
        {
            name: 'Funny',
            definition: 'providing fun; causing amusement or laughter; amusing; comical: a funny remark;'
        },
        {
            name: 'Intelligent',
            definition: 'having good understanding or a high mental capacity; quick to comprehend, as persons or animals;'
        },
        {
            name: 'Brave',
            definition: 'possessing or exhibiting courage or courageous'
        },
        {
            name: 'Unique',
            definition: 'existing as the only one or as the sole example; single; solitary in type or characteristics'
        },
        {
            name: 'Important',
            definition: 'of much or great significance or consequence'
        },
        {
            name: 'Fast',
            definition: 'moving or able to move, operate, function, or take effect quickly; quick; swift; rapida;'
        },
        {
            name: 'Kind',
            definition: 'of a good or benevolent nature or disposition'
        },
        {
            name: 'Honest',
            definition: 'honorable in principles, intentions, and actions; upright and fair'
        },
        {
            name: 'Beautiful',
            definition: 'having beauty; possessing qualities that give great pleasure or satisfaction to see, hear, think about, etc.; delighting the senses or mind'
        },
        {
            name: 'Awesome',
            definition: 'causing or inducing awe; inspiring an overwhelming feeling of reverence, admiration, or fear'
        },
        {
            name: 'Delicious',
            definition: 'highly pleasing to the senses, especially to taste or smell'
        },
        {
            name: 'General',
            definition: 'Yes or No, in a general, non specific sense'
        }
    ]

  end
end