class CriterionBalance
  #TODO figure out and include validations and specs for balance fields
  include Mongoid::Document
  field :criterion, type: Criterion
  field :total_balance, type: Integer, default: 0
  field :used_balance, type: Integer, default: 0
  field :date_last_modified, type: Time
  embedded_in :user

  def remaining_balance
    self.total_balance - self.used_balance
  end
end