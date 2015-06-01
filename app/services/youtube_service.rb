class YoutubeService
  def search_youtube_video_web_things(query)
    begin
      # copied from https://github.com/youtube/api-samples/blob/master/ruby/search.rb
      # Call the search.list method to retrieve results matching the specified
      # query term.
      search_response = $google_api_client.execute!(
          :api_method => $youtube.search.list,
          :parameters => {
              :part => 'snippet',
              :q => query,
              :type => 'video',
              :maxResults => 15
          }
      )
      # Add each result to the appropriate list, and then display the lists of
      # matching videos, channels, and playlists.

      return search_response.data.items.map do |search_result|
        map_youtube_video_search_result_to_web_thing(search_result)
      end
    rescue Google::APIClient::TransmissionError => e
      puts e.result.body
    end
  end

  def get_youtube_video_web_thing(video_id)
    begin
      # copied from https://github.com/youtube/api-samples/blob/master/ruby/search.rb
      # Call the search.list method to retrieve results matching the specified
      # query term.
      search_response = $google_api_client.execute!(
          :api_method => $youtube.videos.list,
          :parameters => {
              :part => 'snippet',
              :type => 'video',
              :id => video_id,
              :maxResults => 15
          }
      )
      # Add each result to the appropriate list, and then display the lists of
      # matching videos, channels, and playlists.

      results = search_response.data.items
      if results.nil? || results.empty?
        return nil
      elsif results.length > 1
        raise StandardError "There should only be one result for youtube video id #{video_id}, but there was #{results.length}"
      else
        return map_youtube_video_to_web_thing(results[0])
      end
    rescue Google::APIClient::TransmissionError => e
      puts e.result.body
    end
  end

  private
  def map_youtube_video_to_web_thing(search_result)
    snippet = search_result['snippet']

    return WebThing.new(
        title: snippet['title'],
        secondary_title: nil,
        external_id: search_result['id'].to_s,
        content: snippet['description'],
        image_uri: snippet['thumbnails']['default']['url'],
        uri: "https://www.youtube.com/watch?v=#{search_result['id'].to_s}",
        type: Scorethings::ThingTypes::YOUTUBE_VIDEO)
  end

  def map_youtube_video_search_result_to_web_thing(search_result)
    # TODO refactor this, I think the only difference between this and
    # youtube channels, is the external_id from id.videoId, check later
    snippet = search_result['snippet']

    return WebThing.new(
        title: snippet['title'],
        secondary_title: nil,
        external_id: search_result['id']['videoId'],
        content: snippet['description'],
        image_uri: snippet['thumbnails']['default']['url'],
        uri: "https://www.youtube.com/watch?v=#{search_result['id']['videoId']}",
        type: Scorethings::ThingTypes::YOUTUBE_VIDEO)
  end
end
