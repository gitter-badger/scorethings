class ThingService
  def initialize
    @twitter_service = TwitterService.new
    @youtube_service = YoutubeService.new
  end

  def find_or_create_by_type_and_external_id(type, external_id)
    thing = Thing.where(type: type, external_id: external_id).first
    if thing.nil?
      unless type == Scorethings::ThingTypes::HASHTAG
        # for things other than hashtag, check that they exist before creating them in database
        external_thing = get_web_thing(type, external_id)
        if external_thing.nil?
          raise Exceptions::WebThingNotFoundError
        end
      end
      thing = Thing.create!(type: type, external_id: external_id)
    end
    return thing
  end

  def search_for_web_things(thing_type, query)
    Rails.cache.fetch("ThingService.search_for_web_things_#{thing_type}_#{query}", :expires_in => 1.hour) do
      if thing_type == Scorethings::ThingTypes::TWITTER_ACCOUNT
        return @twitter_service.search_twitter_account_web_things(query) || []
      elsif thing_type == Scorethings::ThingTypes::YOUTUBE_VIDEO
        return @youtube_service.search_youtube_video_web_things(query) || []
      else
        raise Exceptions::ThingTypeUnknownError
      end
    end
  end

  def get_web_thing(thing_type, external_id)
      web_thing = Rails.cache.fetch("ThingService.get_web_thing_#{thing_type}_#{external_id}", :expires_in => 1.hour) do
        puts "NOT HITTING CACHE get_web_thing"
        case thing_type
          when Scorethings::ThingTypes::HASHTAG
            return WebThing.build_from_hashtag(external_id)
          when Scorethings::ThingTypes::TWITTER_ACCOUNT
            web_thing = @twitter_service.get_twitter_account_web_thing(external_id)
            unless web_thing.nil?
              return web_thing
            end
          when Scorethings::ThingTypes::YOUTUBE_VIDEO
            web_thing = @youtube_service.get_youtube_video_web_thing(external_id)
            unless web_thing.nil?
              return web_thing
            end
          else
            raise Exceptions::ThingTypeUnknownError
        end
        raise Exceptions::WebThingNotFoundError
      end
    return web_thing
  end
end
