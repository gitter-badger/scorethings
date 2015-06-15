require 'dbpedia'

def build_query_string(query)
  """
  PREFIX search: <http://rdf.opensahara.com/search#>
  SELECT ?record
  WHERE {
    ?record a <http://dbpedia.org/resource> .
    ?record ?predicate ?match .
    FILTER(search:text(?match, \"#{query}\"))
  }
  LIMIT 10
  """
end
response = Dbpedia.sparql.query(build_query_string('Comic'))
puts "response: #{response}"
