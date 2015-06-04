class TwitterService
  def search_twitter_account_things(query)
    begin
      if query =~ /https?:\/\/[\S]+/
        begin
          results = $twitter.user(query)
          unless results.empty?
            return [map_twitter_account_to_thing(results[0])]
          end
        rescue Twitter::Error::NotFound
          return []
        end
      else
        search_results = $twitter.user_search(query)
        return search_results.map do |search_result|
          map_twitter_account_to_thing(search_result)
        end
      end
    rescue Twitter::Error::TooManyRequests
      raise Exceptions::ThingRetrievalError
    end
  end

  def get_twitter_account_thing(user_id)
    begin
      return map_twitter_account_to_thing($twitter.user(user_id.to_i))
    rescue Twitter::Error::NotFound
      return nil
    end
  end

  private
  def map_twitter_account_to_thing(twitter_user)
    Thing.new(
        title: "@#{twitter_user.screen_name}",
        secondary_title: twitter_user.name,
        external_id: twitter_user.id,
        image_uri: twitter_user.profile_image_uri(:bigger).to_s,
        uri: twitter_user.uri.to_s,
        verified: twitter_user.verified?,
        content: (twitter_user.description unless !twitter_user.description?),
        type: Scorethings::ThingTypes::TWITTER_ACCOUNT)
  end
end
