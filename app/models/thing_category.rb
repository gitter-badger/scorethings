class ThingCategory
  include Mongoid::Document
  include Mongoid::Search
  include Mongoid::Token

  field :title, type: String

  has_and_belongs_to_many :things
  index({ title: 1 }, { unique: true, name: 'thing_category_title' })
  validates_presence_of :title
  search_in :title

  token :contains => :fixed_numeric, :length => 8

end