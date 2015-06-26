class Thing
  include Mongoid::Document
  include Mongoid::Search
  include Mongoid::Token

  field :wikidata_item_id, type: String
  field :description, type: String
  field :official_websites, type: Array
  field :instance_of_values, type: Array
  field :title, type: String

  has_many :scores, autosave: true, dependent: :delete

  index({ wikidata_item_id: 1 }, { unique: true, name: 'thing_wikidata_item_id_index' })

  token :contains => :fixed_numeric, :length => 8

  search_in :title, :description, :official_websites, :instance_of_values

  validates_presence_of :title, :wikidata_item_id

  def to_builder
    Jbuilder.new do |thing|
      thing.token self.token
      thing.id self.id.to_s
      thing.title self.title
      thing.description self.description
      thing.instance_of_values self.instance_of_values
      thing.wikidata_item_id self.wikidata_item_id
      thing.official_websites self.official_websites
    end
  end

  def self.build_from_wikidata_item(wikidata_item)
    Thing.new(title: wikidata_item[:title],
              wikidata_item_id: wikidata_item[:id],
              official_websites: wikidata_item[:official_websites],
              instance_of_values: wikidata_item[:instance_of_values],
              description: wikidata_item[:description])
  end
end
