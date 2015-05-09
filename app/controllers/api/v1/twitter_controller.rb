module Api
  module V1
    class TwitterController < ApplicationController
      def handle_search
        if params[:twitter_handle]
          twitter_service = TwitterService.new(twitter_uid: @current_user.twitter_uid)
          twitter_user_search_results = twitter_service.search_for_twitter_accounts(params[:twitter_handle])
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

      def user_info
        twitter_uid = params.require(:twitter_uid)
        twitter_uid = twitter_uid.to_i
        twitter_service = TwitterService.new(twitter_uid: @current_user.twitter_uid)
        twitter_account = twitter_service.get_twitter_account_from_uid(twitter_uid)
        if twitter_account.nil?
          return render json: {
                            error: "could not find twitter account information for uid #{twitter_uid}",
                            status: :not_found
                        }, status: :not_found
        else
          return render json: {
                            results: twitter_account,
                            status: :ok
                        }, status: :ok


        end
      end
    end
  end
end