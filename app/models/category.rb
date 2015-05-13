class Category
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :description, type: String
  field :general, type: Boolean, default: false

  validates_presence_of :name, :description
  validates_uniqueness_of :name

  def to_builder
    Jbuilder.new do |category|
      category.(self, :name, :description)
    end
  end
end