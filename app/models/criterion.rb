class Criterion
  include Neo4j::ActiveNode
  property :name
  property :type
  property :definition
end