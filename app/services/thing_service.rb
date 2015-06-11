require 'httpclient'

class ThingService
  def initialize
    @client = HTTPClient.new
  end

  def search(query)
    cache_key = "thing_search(#{query})"
    cached_result = Rails.cache.fetch(cache_key, expires_in: 7.day) do
      search_results = Dbpedia.search(query)
      search_results = search_results.map do |search_result|
        {
            label: search_result.label,
            uri: search_result.uri,
            resource_name: search_result.uri.split('/').last,
            description: search_result.description
        }
      end

      Rails.cache.write(cache_key, search_results)
      return search_results
    end
    return cached_result
  end

  def find(resource_name)
    cache_key = "thing_#{resource_name})"
    cached_result = Rails.cache.fetch(cache_key, expires_in: 7.day) do
      resource = describe(resource_name)
      Rails.cache.write(cache_key, resource)
      return resource
    end
    return cached_result
  end

  def find_or_create_by_resource_name(resource_name)
    thing = Thing.where(resource_name: resource_name).first
    unless thing.nil?
      return thing
    end

    potential_thing = find(resource_name)
    if potential_thing.nil?
      raise Exceptions::PotentialThingNotFoundError
    end

    raise "Oh man, you've totally got to figure out how to get a thing from this json bullshit"
  end

  private
  def describe(resource_name)
    resource_uri = "http://dbpedia.org/resource/#{resource_name}"
    # FIXME this is a quick hack until I can figure out how to use dbpedia and sparql client ruby api gems
    resource_uri["http://"] = "http%3A%2F%2F"
    resource_uri = "#{resource_uri}%3E"
    uri = "http://dbpedia.org/sparql?default-graph-uri=http%3A%2F%2Fdbpedia.org&query=DESCRIBE+%3C#{resource_uri}&output=application%2Fld%2Bjson"

    response = @client.get(uri)
    return response.content
  end
end