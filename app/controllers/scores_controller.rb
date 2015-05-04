class ScoresController < ApplicationController
  def create
    thing_input = params.require(:thing_input).permit(:twitter_handle, :twitter_hashtag)

    twitter_service = TwitterService.new(twitter_uid: @current_user.twitter_uid)
    if !thing_input[:twitter_handle].nil?
      twitter_account = twitter_service.get_twitter_account_from_handle(thing_input[:twitter_handle])
      if twitter_account.nil?
        return render json: {
                     error: "could not find twitter account for twitter handle #{thing_input[:twitter_handle]}",
                     status: :bad_request
                 }, status: :bad_request
      end

      score = @current_user.create_score(thing_type: 'TWITTER_UID', thing_value: twitter_account[:uid])

      render json: {
                 score: score,
                 status: :created
             }, status: :created
    end
  end
end