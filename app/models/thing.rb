class Thing
  include Mongoid::Document
  include Mongoid::Search
  include Mongoid::Token

  field :type, type: String
  field :external_id, type: String

  has_many :scores, autosave: true, dependent: :delete

  token :contains => :fixed_numeric, :length => 8

  validates_presence_of :external_id, :type
  validates_inclusion_of :type,
                         in: [Scorethings::ThingTypes::TWITTER_ACCOUNT,
                              Scorethings::ThingTypes::YOUTUBE_VIDEO,
                              Scorethings::ThingTypes::HASHTAG]

  def to_builder
    Jbuilder.new do |thing|
      thing.id self.id.to_s
      thing.token self.token
      thing.type self.type
      thing.external_id self.external_id
    end
  end
end
