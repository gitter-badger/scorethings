require 'external_id_validator'

class ScoreListThing
  include Mongoid::Document

  field :display_value, type: String
  field :type, type: String
  field :external_id, type: String
  validates_with ExternalIdValidator

  validates_presence_of :display_value, :type

  embedded_in :score_list

  validates_inclusion_of :type,
                         in: [Scorething::ThingTypes::TWITTER_ACCOUNT,
                              Scorething::ThingTypes::YOUTUBE_VIDEO,
                              Scorething::ThingTypes::HASHTAG]

  def self.build_from_thing(thing)
    ScoreListThing.new(
        display_value: thing[:display_value],
        external_id: thing[:external_id],
        type: thing[:type]
    )
  end

  def matches_thing(thing)
    (self.external_id == thing.external_id) && (self.type == thing.type) && (self.display_value == thing.display_value)
  end

  def to_builder
    Jbuilder.new do |score_list_thing|
      score_list_thing.display_value self.display_value
      score_list_thing.type self.type
      score_list_thing.external_id self.external_id
    end
  end
end

