class ThingService

  def search(thing_type, query)
    #Rails.cache.fetch("ThingService.search_#{thing_input}_#{query}", :expires_in => 24.hour) do
      # strip off '@' char at beginning
    #end
    if thing_type == Scorethings::ThingTypes::TWITTER_ACCOUNT
      return search_twitter_account(query)
    elsif thing_type == Scorethings::ThingTypes::YOUTUBE_VIDEO
      return search_youtube_videos(query)
    elsif thing_type == Scorethings::ThingTypes::TWITTER_TWEET
      return search_twitter_tweet(query)
    end
  end

  def find_external_thing(thing_type, query)

  end

  private
  def search_twitter_account(query)
    if query[0] == '@'
      query[0] = ''
    end
    twitter_service = TwitterService.new
    account_results = twitter_service.search_for_twitter_accounts(query)
    account_results.map do |account_result|
      Thing.new(
          title: "@#{account_result.screen_name} (#{account_result.name})",
          external_id: account_result.id,
          image_uri: account_result.profile_image_uri(:bigger).to_s,
          uri: account_result.uri.to_s,
          verified: account_result.verified?,
          description: (account_result.description unless !account_result.description?),
          type: Scorethings::ThingTypes::TWITTER_ACCOUNT)
    end
  end

  def search_youtube_videos(query)
    []
  end

  def search_twitter_tweet(query)
    []
  end
end
