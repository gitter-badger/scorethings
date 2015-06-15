require 'httpclient'

class ThingService
  def initialize
    @client = HTTPClient.new
  end

  def search(query)
    cache_key = "thing_search(#{query})"
    cached_dbpedia_things_from_search = Rails.cache.fetch(cache_key, expires_in: 1.day) do
      search_results = Dbpedia.search(query)
      dbpedia_things_from_search = search_results.map do |search_result|
        DbpediaSearchResult.new(
            label: search_result.label,
            resource_name: search_result.uri.split('/').last,
            description: search_result.description
        )
      end

      Rails.cache.write(cache_key, dbpedia_things_from_search)
      return dbpedia_things_from_search
    end
    return cached_dbpedia_things_from_search
  end

  def find_or_create_from_dbpedia(resource_name)
    thing = Thing.where(resource_name: resource_name).first
    return thing unless thing.nil?

    thing = find_from_dbpedia(resource_name)
    if thing.nil?
      raise Exceptions::DbpediaThingNotFoundError
    end

    thing.save!
    thing
  end

  def find_from_dbpedia(resource_name)
    cache_key = "find_from_dbpedia(#{resource_name})"
    cached_dbpedia_thing = Rails.cache.fetch(cache_key, expires_in: 1.day) do
      dbpedia_thing = query_dbpedia_thing(resource_name)

      if dbpedia_thing.nil?
        raise Exceptions::DbpediaThingNotFoundError
      end

      Rails.cache.write(cache_key, dbpedia_thing)

      return dbpedia_thing
    end
    return cached_dbpedia_thing
  end

  private
  def query_dbpedia_thing(resource_name)
    solutions = Dbpedia.sparql.query(build_query_string(resource_name)).distinct
    # TODO check of one returned

    thing = Thing.new(resource_name: resource_name)
    thing.label = solutions.first[:label].to_s
    thing.description = solutions.first[:abstract].to_s unless solutions.first[:abstract].nil?

    solutions.each do |solution|
      subject = solution.to_hash[:subject].to_s
      thing.thing_categories << ThingCategory.new(resource_name: subject.to_s.split('/').last, label: "NO LABEL YET")
    end

    thing
  end

  def resource(resource_name)
    "<http://dbpedia.org/resource/#{resource_name}>"
  end

  def abstract
    "<http://dbpedia.org/ontology/abstract>"
  end

  def subject
    "<http://purl.org/dc/terms/subject>"
  end

  def label
    "<http://www.w3.org/2000/01/rdf-schema#label>"
  end

  def build_query_string(resource_name)
    """
    SELECT ?subject ?label ?abstract
  WHERE {
    #{resource(resource_name)} #{label} ?label ;
     #{abstract} ?abstract ;
     #{subject} ?subject.
     FILTER(langMatches(lang(?label), 'EN'))
     FILTER(langMatches(lang(?abstract), 'EN'))
  }
  """
  end
end