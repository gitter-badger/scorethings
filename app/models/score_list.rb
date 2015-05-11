class ScoreList
  include Mongoid::Document
  field :name, type: String
  belongs_to :user
  has_and_belongs_to_many :scores

  def to_builder
    Jbuilder.new do |score_list|
      score_list.name self.name
      score_list.scores self.scores
      score_list.id self._id.to_s
    end
  end

  def self.build_from_twitter_list(user, name, twitter_list_members)
    if user.nil? || twitter_list_members.nil?
      # TODO come up with better error(?)
      raise "cannot create score list from twitter list.  both user and twitter list are required."
    end
    new_score_list = ScoreList.new(user: user, name: name)
    twitter_list_members.each do |twitter_list_member|
      score = user.create_or_find_score_for_things(thing_type: 'TWITTER_UID', thing_value: twitter_list_member[:twitter_uid].to_s)
      new_score_list.scores << score
    end
    new_score_list
  end
end