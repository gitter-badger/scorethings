class ThingService
  def initialize
    @twitter_service = TwitterService.new
    @youtube_service = YoutubeService.new
  end

  def find_or_create_by_type_and_external_id(type, external_id)
    thing_reference = ThingReference.where(type: type, external_id: external_id).first
    if thing_reference.nil?
      unless type == Scorethings::ThingTypes::HASHTAG
        # for thingReferences other than hashtag, check that they exist before creating them in database
        external_thing = get_web_thing(type, external_id)
        if external_thing.nil?
          raise Exceptions::WebThingNotFoundError
        end
      end
      thing_reference = ThingReference.create!(type: type, external_id: external_id)
    end
    return thing_reference
  end

  def search_for_web_things(type, query)
    cache_key = "search_for_web_things_#{type}_#{query}"
    return Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      if type == Scorethings::ThingTypes::TWITTER_ACCOUNT
        retrieved_search_results = @twitter_service.search_twitter_account_web_things(query) || []
      elsif type == Scorethings::ThingTypes::YOUTUBE_VIDEO
        retrieved_search_results = @youtube_service.search_youtube_video_web_things(query) || []
      else
        raise Exceptions::ThingTypeUnknownError
      end

      Rails.cache.write(cache_key, retrieved_search_results)
      return retrieved_search_results
    end
  end

  def get_web_thing(type, external_id)
    if type == Scorethings::ThingTypes::HASHTAG
      return WebThing.build_from_hashtag(external_id)
    end
    cache_key = "get_web_thing_#{type}_#{external_id}"
    return Rails.cache.fetch(cache_key, expires_in: 1.day) do
      case type
        when Scorethings::ThingTypes::TWITTER_ACCOUNT
          retrieved_web_thing = @twitter_service.get_twitter_account_web_thing(external_id)
        when Scorethings::ThingTypes::YOUTUBE_VIDEO
          retrieved_web_thing = @youtube_service.get_youtube_video_web_thing(external_id)
        else
          raise Exceptions::ThingTypeUnknownError
      end

      if retrieved_web_thing.nil?
        raise Exceptions::WebThingNotFoundError
      end

      Rails.cache.write(cache_key, retrieved_web_thing)
      return retrieved_web_thing
    end
  end
end
