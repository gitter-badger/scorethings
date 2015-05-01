class Criterion
  include Mongoid::Document
  field :name, type: String
  field :type, type: Integer
  field :definition, type: String
end