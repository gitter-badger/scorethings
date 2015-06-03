class ScoreArchive
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Token

  field :points, type: Integer
  field :meh_floor, type: Integer
  field :meh_ceiling, type: Integer

  embedded_in :score

  token :contains => :fixed_numeric, :length => 8

  def to_builder
    Jbuilder.new do |score|
      score.id self.id
      score.token self.token
      score.points self.points
      score.created_at self.created_at
    end
  end
end
