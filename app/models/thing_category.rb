class ThingCategory
  include Mongoid::Document
  include Mongoid::Search

  field :resource_name, type: String # example: Category:20th-century_American_male_actors
  field :label, type: String # example: 20th-century American male actors

  has_and_belongs_to_many :things

  index({ resource_name: 1 }, { unique: true, name: 'thing_category_resource_name_index' })

  validates_presence_of :resource_name, :label

  search_in :label
end