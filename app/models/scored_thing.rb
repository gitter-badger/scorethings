class ScoredThing
  include Mongoid::Document
  include Mongoid::Search
  include Mongoid::Token

  field :thing_id, type: String
  field :description, type: String
  field :official_websites, type: Array
  field :instance_of_values, type: Array
  field :title, type: String

  has_many :scores, autosave: true, dependent: :delete

  index({ thing_id: 1 }, { unique: true, name: 'scored_thing_thing_id_index' })

  token :contains => :fixed_numeric, :length => 8

  search_in :title, :description, :official_websites, :instance_of_values

  validates_presence_of :title, :thing_id

  def to_builder
    Jbuilder.new do |scored_thing|
      scored_thing.token self.token
      scored_thing.id self.id.to_s
      scored_thing.title self.title
      scored_thing.description self.description
      scored_thing.instance_of_values self.instance_of_values
      scored_thing.thing_id self.thing_id
      scored_thing.official_websites self.official_websites
    end
  end

  def self.build_from_thing(thing)
    ScoredThing.new(title: thing[:title],
              thing_id: thing[:id],
              official_websites: thing[:official_websites],
              instance_of_values: thing[:instance_of_values],
              description: thing[:description])
  end
end
