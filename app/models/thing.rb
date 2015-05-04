class Thing
  include Mongoid::Document
  embedded_in :score
  field :value, type: String
  field :type, type: String
  # TODO rename type to external_identifier_type
  # TODO rename value to external_identifier_value
  validates_inclusion_of :type, in: ['TWITTER_UID', 'TWITTER_HASHTAG']
end