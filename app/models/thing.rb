class Thing
  include Mongoid::Document

  field :value, type: String
  field :type, type: String
  field :external_id, type: String

  validates_presence_of :value

  embedded_in :score

  validates_inclusion_of :type, in: ['TWITTER_UID', 'TWITTER_HASHTAG']

  def to_builder
    Jbuilder.new do |thing|
      thing.value self.value
      thing.type self.type
    end
  end
end