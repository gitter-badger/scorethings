class ThingsController < ApplicationController
  def search
    if params[:twitter_handle]
      twitter_service = TwitterService.new(twitter_uid: @current_user.twitter_uid)
      twitter_user_search_results = twitter_service.search_for_twitter_accounts(twitter_handle: params[:twitter_handle])
      return render json: {
                        results: twitter_user_search_results,
                        status: :ok
                    }, status: :ok
    end

    return render json: {
                      error: "could not determine what thing to search for",
                      status: :bad_request
                  }, status: :bad_request

  end
end