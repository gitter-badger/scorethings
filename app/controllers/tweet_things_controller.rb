class TweetThingsController < ApplicationController
  def search
    tweets = $twitter.search(params[:query], result_type: 'recent').take(10)
    render json: tweets
  end
end