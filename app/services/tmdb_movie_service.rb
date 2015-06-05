class TmdbMovieService
  def initialize
    @movie_search = Tmdb::Search.new
    @movie_search.resource('movie')
    @configuration = Tmdb::Configuration.new
  end

  def search_movie_things(query)
    @movie_search.query(query)
    search_results = @movie_search.fetch
    return search_results.map do |search_result|
      map_tmdb_movie_to_thing(search_result)
    end
  end

  def get_tmdb_movie_thing(id)
    movie_thing = Tmdb::Movie.detail(id)
    unless movie_thing['status_code'].nil?
      raise Exceptions::ThingNotFoundError
    end

    return map_tmdb_movie_to_thing(movie_thing)
  end

  private
  def map_tmdb_movie_to_thing(movie)
    Thing.new(
        title: movie['title'],
        external_id: movie['id'],
        uri: "https://www.themoviedb.org/movie/#{movie['id']}",
        image_uri: movie['poster_path'] &&"#{@configuration.base_url}w92#{movie['poster_path']}",
        type: Scorethings::ThingTypes::TMDB_MOVIE)
  end
end
