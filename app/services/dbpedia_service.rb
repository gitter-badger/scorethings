class DbpediaService
  def search(query)
    cache_key = "dbpedia_service_search(#{query})"

    cached_dbpedia_search_results = Rails.cache.fetch(cache_key, expires_in: 1.day) do
      search_results = Dbpedia.search(query)
      dbpedia_search_results = search_results.map do |search_result|
        DbpediaSearchResult.new(
            label: search_result.label,
            resource_name: search_result.uri.split('/').last,
            description: search_result.description
        )
      end
      Rails.cache.write(cache_key, dbpedia_search_results)
      return dbpedia_search_results
    end

    return cached_dbpedia_search_results
  end


  def find(resource_name)
    cache_key = "dbpedia_service_find(#{resource_name})"
    cached_dbpedia_resource = Rails.cache.fetch(cache_key, expires_in: 1.day) do
      solutions = Dbpedia.sparql.query(build_query_string(resource_name)).distinct
      # TODO check of one returned

      if solutions.nil? || solutions.first.nil?
        raise Exceptions::DbpediaThingNotFoundError
      end

      dbpedia_resource = {
          categories: []
      }
      dbpedia_resource[:resource_name] = resource_name
      dbpedia_resource[:label] = solutions.first[:label].to_s
      dbpedia_resource[:description] = solutions.first[:abstract].to_s unless solutions.first[:abstract].nil?

      solutions.each do |solution|
        subject = solution.to_hash[:subject].to_s
        subject_label = solution.to_hash[:subject_label].to_s
        dbpedia_resource[:categories] << {resource_name: subject.to_s.split('/').last, label: subject_label}
      end

      Rails.cache.write(cache_key, dbpedia_resource)
      return dbpedia_resource
    end
    return cached_dbpedia_resource
  end

private
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
    SELECT ?subject ?subject_label ?label ?abstract
  WHERE {
    #{resource(resource_name)} #{label} ?label ;
     #{abstract} ?abstract ;
     #{subject} ?subject.
      ?subject #{label} ?subject_label.

     FILTER(langMatches(lang(?label), 'EN'))
     FILTER(langMatches(lang(?abstract), 'EN'))
  }
  """
  end
end
