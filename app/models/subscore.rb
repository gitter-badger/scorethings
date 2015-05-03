class Subscore
  include Mongoid::Document
  field :value, type: Integer
  # value is not nil, and is an integer between 0 and 100 inclusively
  validates_numericality_of :value, greater_than_or_equal_to: 0, less_than_or_equal_to: 100, only_integer: true
  validates_presence_of :value
  field :criterion, type: Criterion
  embedded_in :score, inverse_of: :subscores

  def get_score_calculation
    # if criterion type is -1 (a negative criterion), then calculation will be -value
    value * criterion.type
  end
end