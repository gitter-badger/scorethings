class Criterion
  include Mongoid::Document
  include Mongoid::Token

  field :name, type: String
  field :definition, type: String
  field :emoji, type: String, default: ':question:'

  has_many :scores, dependent: :delete

  token :contains => :fixed_numeric, :length => 4

  validates_presence_of :name, :emoji
end