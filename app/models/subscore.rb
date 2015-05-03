class Subscore
  include Mongoid::Document
  field :value, type: Integer
  field :criterion, type: Criterion
  embedded_in :score

  def get_score_calculation
    # if criterion type is -1 (a negative crierion), then calculation will be -value
    value * criterion.type
  end
end