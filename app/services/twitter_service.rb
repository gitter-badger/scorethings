class TwitterService
  def initialize(params)
    if params[:twitter_uid].nil?
      raise "could not use TwitterService, twitter uid is nil"
    end

    @twitter_uid = params[:twitter_uid]
  end

  def search_for_twitter_accounts(twitter_handle)
    Rails.cache.fetch("twitter_handle_search_#{twitter_handle}", :expires_in => 2.hour) do
      $twitter.user_search(twitter_handle)
    end
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
