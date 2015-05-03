class UserPointsTotal
  #TODO figure out and include validations and specs for balance fields
  include Mongoid::Document
  field :amount, type: Integer, default: 0
  field :last_modified, type: Time
  embedded_in :user
end