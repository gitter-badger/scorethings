class TmdbTVService
  def initialize
    @tv_search = Tmdb::Search.new
    @tv_search.resource('tv')
    @configuration = Tmdb::Configuration.new
  end

  def search_tv_things(query)
    @tv_search.query(query)
    search_results = @tv_search.fetch
    return search_results.map do |search_result|
      map_tmdb_tv_to_thing(search_result)
    end
  end

  def get_tmdb_tv_thing(id)
    tv_thing = Tmdb::TV.detail(id)
    unless tv_thing['status_code'].nil?
      raise Exceptions::ThingNotFoundError
    end
    return map_tmdb_tv_to_thing(tv_thing)
  end

  private
  def map_tmdb_tv_to_thing(tv)
    Thing.new(
        title: tv['name'],
        external_id: tv['id'],
        uri: "https://www.themoviedb.org/tv/#{tv['id']}",
        image_uri: tv['poster_path'] && "#{@configuration.base_url}w92#{tv['poster_path']}",
        type: Scorethings::ThingTypes::TMDB_TV)
  end
end
