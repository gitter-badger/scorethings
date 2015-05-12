class Category
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :description, type: String

  validates_presence_of :name, :description

  def to_builder
    Jbuilder.new do |category|
      category.(self, :name, :description)
    end
  end
end