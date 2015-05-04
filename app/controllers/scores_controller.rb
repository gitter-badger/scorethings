class ScoresController < ApplicationController
  def create
    thing_input = params[:thing_input]
    if thing_input.nil?
      render json: {
                 error: "thing_input is required",
                 status: :bad_request
             }, status: :bad_request
    end

    twitter_service = TwitterService.new(twitter_uid: @current_user.twitter_uid)
    if !thing_input[:twitter_handle].nil?
      twitter_account = twitter_service.get_twitter_account_from_handle(thing_input[:twitter_handle])
      if twitter_account.nil?
        render json: {
                   error: "could not find twitter account for twitter handle #{thing_input[:twitter_handle]}",
                   status: :bad_request
               }, status: :bad_request
      else
        score = @current_user.create_score(thing_type: 'TWITTER_UID', thing_value: twitter_account.uid)
        if !score.nil?
          render json: {
                     score: score,
                     status: :created
                 }, status: :created
        end
      end
    end

    # TODO is this correct HTTP code for when I don't know how to handle create request
    render status :unprocessable_entity
  end
end