module Api
  module V1
    class ScoresController < ApplicationController
      skip_before_action :authenticate_request, only: [:show]

      def create
        score = params.require(:score).permit(:thing => [:type, :value])
        thing = score[:thing]

        twitter_service = TwitterService.new(twitter_uid: @current_user.twitter_uid)
        if thing[:type] == 'TWITTER_UID'
          twitter_account = twitter_service.get_twitter_account_from_uid(thing[:value])
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

        elsif thing[:type] == 'TWITTER_HASHTAG'
          score = @current_user.create_score(thing_type: 'TWITTER_HASHTAG', thing_value: thing[:value])
          render json: {
                     score: score,
                     status: :created
                 }, status: :created

        else
          # thing input wasn't a twitter hashtag or handle
          return render json: {
                            error: "failed to create score given the thing type: (#{thing[:type]})",
                            status: :bad_request
                        }, status: :bad_request
        end
      end

      def show
        @score = Score.where(id: params[:id]).first
        if @score.nil?
          return render json: {
                            error: "failed to score for id: #{params[:id]}",
                            status: :not_found
                        }, status: :not_found
        end
      end

      def index
        @scores = Score.all
      end
    end
  end
end