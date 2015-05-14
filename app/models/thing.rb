require 'external_id_validator'

class Thing
  include Mongoid::Document

  field :display_value, type: String
  field :type, type: String
  field :external_id, type: String
  validates_with ExternalIdValidator

  validates_presence_of :display_value, :type
  # may not have external_id, like in the case of hashtags
  # TODO find if there other examples of this.  Will this cause bugs?

  embedded_in :score

  validates_inclusion_of :type,
                         in: [Scorething::ThingTypes::TWITTER_ACCOUNT,
                              Scorething::ThingTypes::YOUTUBE_VIDEO,
                              Scorething::ThingTypes::HASHTAG]

  def to_builder
    Jbuilder.new do |thing|
      thing.display_value self.display_value
      thing.type self.type
      thing.external_id self.external_id
    end
  end
end

