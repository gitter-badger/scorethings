class Thing
  include Mongoid::Document
  include Mongoid::Search
  include Mongoid::Token

  field :title, type: String
  field :type, type: String
  field :external_id, type: String
  field :image_uri, type: String
  field :uri, type: String
  field :description, type: String
  field :verified, type: Boolean, default: false

  has_many :scores, autosave: true, dependent: :delete

  token :contains => :fixed_numeric, :length => 8
  search_in :title, :description

  validates_presence_of :external_id, :title, :type
  validates_inclusion_of :type,
                         in: [Scorethings::ThingTypes::TWITTER_ACCOUNT,
                              Scorethings::ThingTypes::TWITTER_TWEET,
                              Scorethings::ThingTypes::YOUTUBE_VIDEO,
                              Scorethings::ThingTypes::HASHTAG]

  def to_builder
    Jbuilder.new do |thing|
      thing.id self.id.to_s
      thing.token self.token
      thing.description self.description
      thing.title self.title
      thing.type self.type
      thing.external_id self.external_id
      thing.image_uri self.image_uri
      thing.uri self.uri
      thing.verified self.verified
    end
  end

  def self.create_hashtag_thing(hashtag_value)
    #TODO strip hashtag_value of # or @ symbols for external_id?
    Thing.create(
             type: Scorethings::ThingTypes::HASHTAG,
             external_id: hashtag_value,
             title: "##{hashtag_value}"
    )
  end
end

