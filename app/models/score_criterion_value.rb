class ScoreCriterionValue
  include Mongoid::Document
  field :value, type: Integer
  has_one :criterion
  embedded_in :score
end