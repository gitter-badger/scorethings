class ThingService
  def initialize
    @twitter_service = TwitterService.new
    @github_service = GithubService.new
    @soundcloud_service = SoundcloudService.new
  end

  def find_or_create_thing_reference_to_thing(type, external_id)
    thing_reference = ThingReference.where(type: type, external_id: external_id).first
    if thing_reference.nil?
      unless type == Scorethings::ThingTypes::HASHTAG
        # for thingReferences other than hashtag, check that they exist before creating them in database
        external_thing = get_thing(type, external_id)
        if external_thing.nil?
          raise Exceptions::ThingNotFoundError
        end
      end
      thing_reference = ThingReference.create!(type: type, external_id: external_id)
    end
    return thing_reference
  end

  def search_for_things(type, query)
    cache_key = "search_for_things_#{type}_#{query}"
    return Rails.cache.fetch(cache_key, expires_in: 1.day) do
      case type
        when Scorethings::ThingTypes::TWITTER_ACCOUNT
          retrieved_search_results = @twitter_service.search_twitter_account_things(query) || []
        when Scorethings::ThingTypes::GITHUB_REPOSITORY
          retrieved_search_results = @github_service.search_github_repository_things(query) || []
        when Scorethings::ThingTypes::SOUNDCLOUD_TRACK
          retrieved_search_results = @soundcloud_service.search_soundcloud_track_things(query) || []
        else
          raise Exceptions::ThingTypeUnknownError
      end

      Rails.cache.write(cache_key, retrieved_search_results)
      return retrieved_search_results
    end
  end

  def get_thing(type, external_id)
    if type == Scorethings::ThingTypes::HASHTAG
      return Thing.build_from_hashtag(external_id)
    end
    cache_key = "get_thing_#{type}_#{external_id}"
    return Rails.cache.fetch(cache_key, expires_in: 1.day) do
      case type
        when Scorethings::ThingTypes::TWITTER_ACCOUNT
          thing = @twitter_service.get_twitter_account_thing(external_id)
        when Scorethings::ThingTypes::GITHUB_REPOSITORY
          thing = @github_service.get_github_repository_thing(external_id)
        when Scorethings::ThingTypes::SOUNDCLOUD_TRACK
          thing = @soundcloud_service.get_soundcloud_track_thing(external_id)
        else
          raise Exceptions::ThingTypeUnknownError
      end

      if thing.nil?
        raise Exceptions::ThingNotFoundError
      end

      Rails.cache.write(cache_key, thing)
      return thing
    end
  end
end
