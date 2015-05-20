require 'external_id_validator'

class Thing
  include Mongoid::Document

  field :title, type: String
  field :type, type: String
  field :external_id, type: String
  field :image_uri, type: String
  field :uri, type: String
  field :description, type: String
  field :verified, type: Boolean, default: false

  has_many :scores, autosave: true
  has_and_belongs_to_many :score_lists

  validates_with ExternalIdValidator

  validates_presence_of :title, :type
  validates_inclusion_of :type,
                         in: [Scorethings::ThingTypes::TWITTER_ACCOUNT,
                              Scorethings::ThingTypes::YOUTUBE_VIDEO,
                              Scorethings::ThingTypes::HASHTAG]

  def to_builder
    Jbuilder.new do |thing|
      thing.(self, :id, :title, :type, :external_id, :image_uri, :image_uri, :uri, :description, :verified)
    end
  end
end

