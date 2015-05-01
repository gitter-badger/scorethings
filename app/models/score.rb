class Score 
  include Neo4j::ActiveNode
  has_one :out, :subject
  has_one :in, :user
  has_many :out, :score_criteria
end