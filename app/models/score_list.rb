class ScoreList
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  include Mongoid::Token

  field :name, type: String
  has_and_belongs_to_many :scores, inverse_of: :score_lists
  belongs_to :user
  has_and_belongs_to_many :things, autosave: true

  token :contains => :fixed_numeric, :length => 8
  search_in :name

  validates_presence_of :name
  validates_presence_of :user

  def to_builder
    Jbuilder.new do |score_list|
      score_list.name self.name
      score_list.token self.token
      score_list.id self.token
    end
  end

  def self.build_score_list_from_score(score)
    score_user = score.user
    if score_user.nil?
      return
    end
    score_list = score_user.create_score_list(name: "Score List Built From Score #{score.token}")
    score_list.scores << score
    score_list.things << score.thing
    return score_list
  end

  def average_score
    total = 0
    if self.scores.empty?
      return total
    end

    self.scores.each do |score|
      total += score.points
    end

    (total / self.scores.length.to_f).round
  end
end