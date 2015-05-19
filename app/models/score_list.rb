class ScoreList
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  has_and_belongs_to_many :scores, inverse_of: :score_lists
  belongs_to :user
  embeds_many :score_list_things

  validates_presence_of :name
  validates_presence_of :user

  def to_builder
    Jbuilder.new do |score_list|
      score_list.name self.name
      score_list.id self.id.to_s
      score_list.num_of_scores self.scores.length
    end
  end

  def self.build_score_list_from_score(score)
    score_user = score.user
    if score_user.nil?
      return
    end
    score_list = score_user.create_score_list(name: "Score List For #{score.thing.display_value}")
    score_list.scores << score
    score_list.score_list_things << ScoreListThing.build_from_thing(score.thing)
    score_list
  end

  def has_score_list_thing_matching_thing(thing)
    # FIXME find better way with ruby to do this

    self.score_list_things.each do |score_list_thing|
      if score_list_thing.matches_thing(thing)
        return true
      end
    end

    return false
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