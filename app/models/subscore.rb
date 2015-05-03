class Subscore
  include Mongoid::Document
  field :value, type: Integer
  field :criterion, type: Criterion
  embedded_in :score

  def get_score_calculation
    value * criterion.type
  end
end