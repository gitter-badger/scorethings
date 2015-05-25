class ThingService
  def initialize
    @twitter_service = TwitterService.new
    @youtube_service = YoutubeService.new
  end

  def search(thing_type, query)
    #Rails.cache.fetch("ThingService.search_#{thing_input}_#{query}", :expires_in => 24.hour) do
      # strip off '@' char at beginning
    #end
    if thing_type == Scorethings::ThingTypes::TWITTER_ACCOUNT
      return search_twitter_account(query)
    elsif thing_type == Scorethings::ThingTypes::TWITTER_TWEET
      return search_twitter_tweet(query)
    elsif thing_type == Scorethings::ThingTypes::YOUTUBE_VIDEO
      return search_youtube_videos(query)
    else
      raise "unimplemented search for thing type: #{thing_type}"
    end
  end

  def load_external_thing(thing_type, external_id)
    if thing_type == Scorethings::ThingTypes::TWITTER_ACCOUNT
      return load_twitter_account(external_id)
    elsif thing_type == Scorethings::ThingTypes::TWITTER_TWEET
      return load_twitter_tweet(external_id)
    elsif thing_type == Scorethings::ThingTypes::YOUTUBE_VIDEO
      return load_youtube_video(external_id)
    else
      raise "unimplemented load for thing type: #{thing_type}"
    end
  end


  private
  def search_twitter_account(query)
    if query[0] == '@'
      query[0] = ''
    end
    @twitter_service.search_for_twitter_accounts(query)
  end

  def search_twitter_tweet(query)
    @twitter_service.search_for_twitter_tweets(query)
  end

  def search_youtube_videos(query)
    @youtube_service.search_for_videos(query)
  end

  def load_youtube_video(video_id)
    @youtube_service.load_video(video_id)
  end

  def load_twitter_account(user_id)
    @twitter_service.load_user(user_id)
  end

  def load_twitter_tweet(tweet_status_id)
    @twitter_service.load_tweet(tweet_status_id)
  end
end
