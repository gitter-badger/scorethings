module Api
  module V1
    class ScoresController < ApplicationController
      skip_before_action :authenticate_request, only: [:show, :search]

      def search
        query = params[:query]
        user_id = params[:user_id]
        if user_id.nil?
          @scores = Score.full_text_search(query, allow_empty_search: true)
        else
          # user specified, search scores that belong to that user
          begin
            user = User.find(user_id)
            @scores = user.scores.full_text_search(query, allow_empty_search: true)
          rescue Mongoid::Errors::DocumentNotFound
            return render json: {
                              error: "Could not find user with id #{user_id}",
                              status: :not_found
                          }, status: :not_found
          end
        end
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
        score_params = params.require(:score).permit(:score_category_id, :thing_id, :points)
        if score_params[:thing_id].nil?
          return render json: {
                            error: "thing_id is required",
                            status: :bad_request
                        }, status: :bad_request

        end
        begin
          score = Score.new(score_params)
          thing = Thing.find(score_params[:thing_id])
          score.thing = thing

          @score = @current_user.create_score(score)
          return render template: '/api/v1/scores/create.jbuilder', status: :created, formats: [:json]
        rescue Mongoid::Errors::DocumentNotFound
          return render json: {
                            status: :not_found
                        }, status: :not_found
        rescue Mongoid::Errors::Validations => error
          return render json: {
                            error: "failed to create score: #{error.full_messages.to_s}",
                            status: :bad_request
                        }, status: :bad_request
        end
      end

      def update
        begin
          @score = Score.find(params.require(:id))
          score_params = params.require(:score).permit(:points, :score_category_id)
          @current_user.change_score(@score, score_params)
        rescue Mongoid::Errors::DocumentNotFound
          return render json: {
                            status: :not_found
                        }, status: :not_found
        rescue Exceptions::UnauthorizedModificationError
          return render json: {
                            error: "failed to change score for id: #{params[:id]}",
                            status: :forbidden
                        }, status: :forbidden
        end
      end

      def destroy
        id = params.require(:id)
        begin
          @score = Score.find(id)
          @current_user.delete_score(@score)
          return render json: {
                            status: :ok
                        }, status: :ok
        rescue Mongoid::Errors::DocumentNotFound
          return render json: {
                            error: "failed to score for id: #{id}",
                            status: :not_found
                        }, status: :not_found
        rescue Exceptions::UnauthorizedModificationError
          return render json: {
                            error: "failed to delete score for id: #{id}",
                            status: :forbidden
                        }, status: :forbidden
        end
      end

      def show
        id = params.require(:id)
        begin
          @score = Score.find(id)
        rescue Mongoid::Errors::DocumentNotFound
            return render json: {
                              error: "failed to score for id: #{params[:id]}",
                              status: :not_found
                          }, status: :not_found
        end
      end
   end
  end
end
