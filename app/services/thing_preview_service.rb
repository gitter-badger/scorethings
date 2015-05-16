class ThingPreviewService

  def preview_twitter_account(thing_input)
    Rails.cache.fetch("preview_twitter_account#{thing_input}", :expires_in => 1.hour) do
      # strip off '@' char at beginning
      if thing_input[0] == '@'
        thing_input[0] = ''
      end
      twitter_service = TwitterService.new
      account_results = twitter_service.search_for_twitter_accounts(thing_input)
      account_results.map do |account_result|
        puts "profile image: (#{account_result.profile_image_uri})"
        ThingPreview.new(
            display_value: "@#{account_result.screen_name}",
            external_id: account_result.id,
            image_uri: account_result.profile_image_uri,
            uri: account_result.uri.to_s,
            type: Scorething::ThingTypes::TWITTER_ACCOUNT)
      end
    end
  end
end
