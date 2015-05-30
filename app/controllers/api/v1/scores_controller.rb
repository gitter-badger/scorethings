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

      def create
        score_params = params.require(:score).permit(:score_category_id, :thing_id, :points, :thing => [:external_id, :type])
        thing_params = score_params[:thing]

        if thing_params.nil?
          thing_id = score_params[:thing_id]
          thing = Thing.where(id: thing_id).first
        else
          thing_service = ThingService.new
          thing = thing_service.load_external_thing(thing_params[:type], thing_params[:external_id])
        end

        if thing.nil?
          return render json: {
                            error: "failed to find thing for score",
                            status: :bad_request
                        }, status: :bad_request
        end


        begin
          if score_params[:score_category_id].nil?
            score_category = ScoreCategory.where(general: true).first
          else
            # if params did not include score category, or one couldn't be found, use the general one
            score_category = ScoreCategory.where(id: score_params[:score_category_id]).first
          end
          score = Score.new(score_params)
          score.thing = thing
          score.score_category = score_category

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
