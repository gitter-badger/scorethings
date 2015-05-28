class Score
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  include Mongoid::Token

  field :points, type: Integer, default: 0

  belongs_to :user, dependent: :destroy
  belongs_to :score_category, dependent: :destroy
  belongs_to :thing, dependent: :destroy
  has_and_belongs_to_many :score_lists, inverse_of: :scores

  token :contains => :fixed_numeric, :length => 8
  search_in :thing => [:description, :title]

  validates_numericality_of :points, greater_than_or_equal_to: 0, less_than_or_equal_to: 100, only_integer: true

  def to_builder
    Jbuilder.new do |score|
      score.id self.id
      score.token self.token
      score.user self.user.to_builder
      score.thing self.thing.to_builder
      score.points self.points
    end
  end
end