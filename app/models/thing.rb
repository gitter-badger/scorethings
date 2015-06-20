class Thing
  include Mongoid::Document
  include Mongoid::Search
  include Mongoid::Token

  field :wikidata_item_id, type: String
  field :description, type: String
  field :official_websites, type: Array
  field :title, type: String

  has_many :scores, autosave: true, dependent: :delete

  index({ wikidata_item_id: 1 }, { unique: true, name: 'thing_wikidata_item_id_index' })

  token :contains => :fixed_numeric, :length => 8

  search_in :title, :description, :official_websites

  validates_presence_of :title, :wikidata_item_id

  def self.build_from_wikidata_item(wikidata_item)
    Thing.new(title: wikidata_item[:title],
              wikidata_item_id: wikidata_item[:id],
              official_websites: wikidata_item[:official_websites],
              description: wikidata_item[:description])
  end
end
