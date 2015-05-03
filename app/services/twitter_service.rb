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
end
