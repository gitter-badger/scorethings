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
      Rails.cache.fetch("twitter_user_info_#{twitter_uid}", :expires_in => 2.hour) do
        $twitter.user(twitter_uid)
      end
    rescue Twitter::Error::NotFound
      nil
    end
  end
end
