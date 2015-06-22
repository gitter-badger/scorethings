class OldPoints
  include Mongoid::Document

  field :points, type: Integer
  field :started_at, type: Time
  field :ended_at, type: Time

  embedded_in :score
  validates_presence_of :points
end
