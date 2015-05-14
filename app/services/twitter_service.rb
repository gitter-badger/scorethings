class TwitterService
  def search_for_twitter_accounts(twitter_handle)
    Rails.cache.fetch("twitter_handle_search_#{twitter_handle}", :expires_in => 2.hour) do
      $twitter.user_search(twitter_handle)
    end
  end

  def account_exists(twitter_uid)
    !get_twitter_account_from_uid(twitter_uid).nil?
  end

  def get_twitter_account_from_uid(twitter_uid)
    begin
      Rails.cache.fetch("twitter_user_info_for_uid_#{twitter_handle}", :expires_in => 2.hour) do
        $twitter.user(twitter_uid.to_i)
      end
    rescue Twitter::Error::NotFound
      nil
    end
  end

  def get_twitter_account_from_handle(twitter_handle)
    begin
      Rails.cache.fetch("twitter_user_info_for_handle_#{twitter_handle}", :expires_in => 2.hour) do
        $twitter.user(twitter_handle)
      end
    rescue Twitter::Error::NotFound
      nil
    end
  end

  def get_twitter_account_thing_from_params(thing_params)
    twitter_account = nil
    if !thing_params[:external_id].nil?
      twitter_account = get_twitter_account_from_uid(thing_params[:external_id])
    elsif !thing_params[:display_value].nil?
      twitter_account = get_twitter_account_from_handle(thing_params[:display_value])
    end

    if twitter_account.nil?
      return nil
    end

    Thing.new(type: Scorething::ThingTypes::TWITTER_ACCOUNT, display_value: twitter_account[:screen_name], external_id: twitter_account[:id])
  end
end
