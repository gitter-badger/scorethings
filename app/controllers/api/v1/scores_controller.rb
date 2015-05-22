module Api
  module V1
    class ScoresController < ApplicationController
      skip_before_action :authenticate_request, only: [:show, :search]

      def search
        query = params[:query]
        @scores = Score.full_text_search(query)
      end

      def score_thing
        score_params = params.require(:score).permit(:points, :score_category_id)
        score_category_id = score_params[:score_category_id]
        thing_type = params.require(:thing_type)
        external_id = params.require(:external_id)

        thing = Thing.where(type: thing_type, external_id: external_id).first
        valid_thing_types = [Scorethings::ThingTypes::TWITTER_ACCOUNT,
                             Scorethings::ThingTypes::TWITTER_TWEET,
                             Scorethings::ThingTypes::YOUTUBE_VIDEO,
                             Scorethings::ThingTypes::HASHTAG]

        # FIXME This is bad, hard to read flow,  I'm gonna fix it
        if thing.nil?
          if thing_type == Scorethings::ThingTypes::HASHTAG
            thing = Thing.create_hashtag_thing(external_id)
          elsif valid_thing_types.include? thing_type
            thing_service = ThingService.new
            thing = thing_service.load_external_thing(thing_type, external_id)
            thing.save! unless thing.nil?
          end
        end

        if thing.nil?
          return render json: {
                            error: "Can't find thing with type #{thing_type} and external_id #{external_id}",
                            status: :not_found
                        }, status: :not_found
        elsif !thing.valid?
          return render json: {
                            error: "Failed to create thing for score, it was invalid: (#{thing.errors.full_messages.to_s})",
                            status: :bad_request
                        }, status: :bad_request
        end

        if score_category_id.nil?
          score_category = ScoreCategory.where(general: true).first
        else
          # if params did not include score category, or one couldn't be found, use the general one
          score_category = ScoreCategory.where(id: score_params[:score_category_id]).first
        end

        score_params[:thing_id] = thing[:id]
        score = Score.new(score_params)
        score.thing = thing
        score.score_category = score_category

        begin
          @score = @current_user.create_score(score)
          return render template: '/api/v1/scores/score_thing.jbuilder', status: :created, formats: [:json]
        rescue Mongoid::Errors::Validations => error
          return render json: {
                            error: "#{error.full_messages.to_s}",
                            status: :bad_request
                        }, status: :bad_request
        end
      end

      def create
        raise "unimplemented, I will...like..totally get to this soon"
      end

      def update
        @score = Score.where(id: params[:id]).first
        if @score.nil?
          return render json: {
                            error: "failed to score for id: #{params[:id]}",
                            status: :not_found
                        }, status: :not_found
        end

        begin
          score_params = params.require(:score).permit(:points, :score_category_id)
          @current_user.change_score(@score, score_params)
        rescue UnauthorizedModificationError
          return render json: {
                            error: "failed to change score for id: #{params[:id]}",
                            status: :forbidden
                        }, status: :forbidden
        end
      end

      def destroy
        @score = Score.where(id: params[:id]).first
        if @score.nil?
          return render json: {
                            error: "failed to score for id: #{params[:id]}",
                            status: :not_found
                        }, status: :not_found
        end
        begin
          @current_user.delete_score(@score)
          return render json: {
                            status: :ok
                        }, status: :ok
        rescue UnauthorizedModificationError
          return render json: {
                            error: "failed to delete score for id: #{params[:id]}",
                            status: :forbidden
                        }, status: :forbidden
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
   end
  end
end
