class UserCriterionScoreBalance
  include Mongoid::Document
  field :criterion, type: Criterion
  field :remaining_balance, type: Integer
  field :date_last_modified, type: Time
  embedded_in :user
end