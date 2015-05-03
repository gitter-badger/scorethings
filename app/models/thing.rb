class Thing
  include Mongoid::Document
  embedded_in :score
  field :value, type: String
  field :type, type: String
  validates_inclusion_of :type, in: ['twitter_handle', 'twitter_hashtag']
end