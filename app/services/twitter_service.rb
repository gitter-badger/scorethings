class TwitterService
  def initialize(params)
    if params[:twitter_uid].nil?
      raise "could not use TwitterService, twitter uid is nil"
    end

    @twitter_uid = params[:twitter_uid]
  end

  def get_lists
    $twitter.lists(@twitter_uid.to_i)
  end

  def search_for_twitter_accounts(attrs)
    if attrs[:twitter_handle]
      $twitter.user_search(attrs[:twitter_handle])
    end
  end

  def get_twitter_account_from_uid(twitter_uid)

  end
end
