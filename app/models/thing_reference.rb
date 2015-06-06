class ThingReference
  include Mongoid::Document
  include Mongoid::Search
  include Mongoid::Token

  field :type, type: String
  field :external_id, type: String

  has_many :scores, autosave: true, dependent: :delete

  token :contains => :fixed_numeric, :length => 8

  search_in :external_id

  validates_presence_of :external_id, :type
  validates_inclusion_of :type,
                         in: [Scorethings::ThingTypes::TWITTER_ACCOUNT,
                              Scorethings::ThingTypes::GITHUB_REPOSITORY,
                              Scorethings::ThingTypes::SOUNDCLOUD_TRACK,
                              Scorethings::ThingTypes::TMDB_MOVIE,
                              Scorethings::ThingTypes::TMDB_TV,
                              Scorethings::ThingTypes::HASHTAG]

  def to_builder
    Jbuilder.new do |thing|
      thing.id self.id.to_s
      thing.token self.token
      thing.type self.type
      thing.external_id self.external_id
    end
  end

  def self.find_hashtag_thing_by_external_id(external_id)
    thing_refereneces = ThingReference.full_text_search(external_id)
    things = thing_refereneces.all.map do |hashtag_thing_reference|
      Thing.new(title: "##{hashtag_thing_reference.external_id}",
                external_id: hashtag_thing_reference.external_id,
                type: Scorethings::ThingTypes::HASHTAG)
    end
    return things
  end
end
