require 'dbpedia'
require 'httpclient'

resource_uri = "http://dbpedia.org/resource/Patton_Oswalt"
resource_uri["http://"] = "http%3A%2F%2F"
resource_uri = "#{resource_uri}%3E"
client = HTTPClient.new

uri = "http://dbpedia.org/sparql?default-graph-uri=http%3A%2F%2Fdbpedia.org&query=DESCRIBE+%3C#{resource_uri}&output=application%2Fld%2Bjson"
puts uri
