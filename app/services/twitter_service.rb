class TwitterService
  def search_for_twitter_accounts(query)
    Rails.cache.fetch("twitter_handle_search_#{query}", :expires_in => 8.hour) do
      # FIXME Nooooope...what if someone has a twitter account that starts with http?
      if query.start_with?('http')
        begin
          twitter_user = $twitter.user(query)
          return [map_user_to_thing(twitter_user)]
        rescue Twitter::Error::NotFound
          return []
        end
      else
        search_results = $twitter.user_search(query)
        return search_results.map do |search_result|
          map_user_to_thing(search_result)
        end
      end
    end
  end

  def search_for_twitter_tweets(query)
    Rails.cache.fetch("search_for_twitter_tweets#{query}", :expires_in => 1.hour) do
      begin
        # FIXME Nooooope...what if someone has a twitter account that starts with http?
        if query.start_with?('http')
            status = query.match('\/(\d+)$')
            if status.nil?
              return []
            else
              begin
                tweet = $twitter.status(status[1])
                return [map_tweet_to_thing(tweet)]
              rescue Twitter::Error::NotFound
                return []
              end
            end
        else
          search_results = $twitter.search(query, result_type: 'recent').take(10)
          return search_results.map do |search_result|
            map_tweet_to_thing(search_result)
          end
        end
      rescue Twitter::Error::TooManyRequests
        puts "Too Many Twitter Requests"
        return []
      end
    end
  end

  def load_user(user_id)
    Rails.cache.fetch("load_user(#{user_id})", :expires_in => 4.hour) do
      begin
        map_user_to_thing($twitter.user(user_id.to_i))
      rescue Twitter::Error::NotFound
        return nil
      end
    end
  end

  def load_tweet(tweet_status_id)
    Rails.cache.fetch("load_tweet(#{tweet_status_id})", :expires_in => 1.hour) do
      begin
        map_tweet_to_thing($twitter.status(tweet_status_id))
      rescue Twitter::Error::NotFound
        return nil
      end
    end
  end

  # FIXME I'm not sure how to write tests for this, the mapping functions, yet.
  # I need to figure out how to deal with mock Twitter::SearchResults, so
  # I'm just going to not have the mapping functions private until I can,
  # so I can have tests for it
  #private

  # TODO I think there should take advantage of mongoid doc inheritence, so tweets
  # have more metadata particular to tweets, or youtube videos, or whatever
  # but, I do want Things to be generic...I don't know....I'll think about it
  # http://mongoid.org/en/mongoid/docs/documents.html#inheritance

  def map_user_to_thing(twitter_user)
    Thing.new(
        title: "@#{twitter_user.screen_name} (#{twitter_user.name})",
        external_id: twitter_user.id,
        image_uri: twitter_user.profile_image_uri(:bigger).to_s,
        uri: twitter_user.uri.to_s,
        verified: twitter_user.verified?,
        description: (twitter_user.description unless !twitter_user.description?),
        type: Scorethings::ThingTypes::TWITTER_ACCOUNT)
  end

  def map_tweet_to_thing(tweet)
    Thing.new(
        title: "Tweet From @#{tweet.user.screen_name} at #{tweet.created_at.strftime("%A, %d %b %Y %l:%M %p")}",
        external_id: tweet.id,
        image_uri: tweet.user.profile_image_uri(:bigger).to_s,
        uri: tweet.uri.to_s,
        verified: tweet.user.verified?,
        description: tweet.text,
        type: Scorethings::ThingTypes::TWITTER_TWEET)
  end
end
