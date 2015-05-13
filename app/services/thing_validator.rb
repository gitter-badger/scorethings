class ThingValidator
  def check_validity(thing)
    if thing[:type] == 'TWITTER_UID'
      twitter_service = TwitterService.new
      if !twitter_service.account_exists(thing[:value])
        raise InvalidThingError, "twitter uid #{thing[:value]} could not be found"
      end
    end
    return true
  end
end
