class Criterion
  include Mongoid::Document
  include Mongoid::Token

  field :name, type: String

  has_many :scores, dependent: :delete

  token :contains => :fixed_numeric, :length => 8

  validates_presence_of :name
  validates_length_of :name, minimum: 2, maximum: 20
end
