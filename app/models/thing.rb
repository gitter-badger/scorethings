class Thing
  include Mongoid::Document
  include Mongoid::Search
  include Mongoid::Token

  field :resource_name, type: String
  field :label, type: String
  field :description, type: String

  has_many :scores, autosave: true, dependent: :delete

  token :contains => :fixed_numeric, :length => 8

  search_in :resource_name, :label, :description

  validates_presence_of :resource_name, :label

  def to_builder
    Jbuilder.new do |thing|
      thing.id self.id.to_s
      thing.token self.token
      thing.resource_name self.resource_name
      thing.label self.label
      thing.description self.description
    end
  end
end
