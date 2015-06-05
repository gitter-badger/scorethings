class SoundcloudService
  def search_soundcloud_track_things(query)
    # FIXME uses legacy search, allowing for query qualifiers
    # ex: https://api.github.com/search/repositories?q=tetris+language:assembly&sort=stars&order=desc
    # should ensure query isn't a security hole
    # https://developer.github.com/v3/search/

    if query =~ /https?:\/\/[\S]+/
      track_url = query
      track = $soundcloud.get('/resolve', url: track_url)
      return [map_soundcloud_search_result_track_to_thing(track)]
    end

    search_results = $soundcloud.get('/tracks', q: query)

    return search_results.map do |search_result|
      map_soundcloud_search_result_track_to_thing(search_result)
    end
  end

  def get_soundcloud_track_thing(track_id)
    track = $soundcloud.get("/tracks/#{track_id}")
    puts "\n\n\ntrack: #{track}"
    return map_soundcloud_search_result_track_to_thing(track)
  end

  private
  def map_soundcloud_search_result_track_to_thing(search_result)
    Thing.new(
        title: search_result[:title],
        external_id: search_result[:id],
        uri: search_result[:permalink_url],
        image_uri: search_result[:artwork_url],
        type: Scorethings::ThingTypes::SOUNDCLOUD_TRACK)
  end
end
