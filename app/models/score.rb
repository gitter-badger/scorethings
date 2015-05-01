class Score
  include Mongoid::Document
  embeds_many :score_criterion_values
end