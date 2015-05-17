class ThingPreviewService

  def preview_twitter_account(thing_input)
    #Rails.cache.fetch("preview_twitter_account#{thing_input}", :expires_in => 24.hour) do
      # strip off '@' char at beginning
      if thing_input[0] == '@'
        thing_input[0] = ''
      end
      twitter_service = TwitterService.new
      account_results = twitter_service.search_for_twitter_accounts(thing_input)
      account_results.map do |account_result|
        ThingPreview.new(
            display_value: "@#{account_result.screen_name}",
            real_name: account_result.name,
            external_id: account_result.id,
            image_uri: account_result.profile_image_uri.to_s,
            uri: account_result.uri.to_s,
            verified: account_result.verified?,
            description: (account_result.description unless !account_result.description?),
            type: Scorething::ThingTypes::TWITTER_ACCOUNT)
      end
    #end
  end
end
