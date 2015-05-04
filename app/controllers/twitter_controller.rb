class TwitterController < ApplicationController
  def lists
    twitter_service = TwitterService.new(twitter_uid: @current_user.twitter_uid)
    lists = twitter_service.get_lists
    render json: lists
  end
end