class Subscore
  include Mongoid::Document
  field :value, type: Integer
  belongs_to :criterion
  embedded_in :score

  # value is not nil, and is an integer between 0 and 99 inclusively
  validates_numericality_of :value, greater_than_or_equal_to: 0, less_than: 100, only_integer: true
  validates_presence_of :value, :criterion

  def get_score_calculation
    # if criterion sign is -1 (a negative criterion), then calculation will be -value
    value * criterion.sign
  end

  def to_builder
    Jbuilder.new do |subscore|
      subscore.value self.value
      subscore.criterion self.criterion.to_builder
    end
  end
end