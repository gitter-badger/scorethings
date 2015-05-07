module Api
  module V1
    class ScoresController < ApplicationController
      skip_before_action :authenticate_request, only: [:show]

      def create
        puts "\n\n#{params[:thing_input]}"
        thing_input = params.require(:thing_input).permit(:twitter_uid, :twitter_hashtag)

        twitter_service = TwitterService.new(twitter_uid: @current_user.twitter_uid)
        if !thing_input[:twitter_uid].nil?
          twitter_account = twitter_service.get_twitter_account_from_uid(thing_input[:twitter_uid])
          if twitter_account.nil?
            return render json: {
                         error: "could not find twitter account for twitter user id '#{thing_input[:twitter_uid]}'",
                         status: :bad_request
                     }, status: :bad_request
          end

          score = @current_user.create_score(thing_type: 'TWITTER_UID', thing_value: twitter_account[:uid])

          return render json: {
                     score: score,
                     status: :created
                 }, status: :created
        elsif !thing_input[:twitter_hashtag].nil?
          score = @current_user.create_score(thing_type: 'TWITTER_HASHTAG', thing_value: thing_input[:twitter_hashtag])
          render json: {
                     score: score,
                     status: :created
                 }, status: :created
        else
          # thing input wasn't a twitter hashtag or handle
          return render json: {
                            error: "the only accepted POST data are thing_input['twitter_handle'] and thing_input['twitter_hashtag']",
                            status: :bad_request
                        }, status: :bad_request

        end
      end

      def show
        score = Score.where(id: params[:id]).first
        if score.nil?
          return render json: {
                            error: "unable to find score",
                            status: :not_found
                        }, status: :not_found
        else
          return render json: {
                            score: score,
                            status: :ok
                        }, status: :ok
        end
      end
    end
  end
end
