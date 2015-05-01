class Subject 
  include Neo4j::ActiveNode
  property :type
  property :value
end