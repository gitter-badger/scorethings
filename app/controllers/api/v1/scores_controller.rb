module Api
  module V1
    class ScoresController < ApplicationController
      skip_before_action :authenticate_request, only: [:show]

      def create
        score = params.require(:score).permit(:points, :score_category_id, {:thing => [:type, :value]})
        score_category = nil
        score_category_id = score[:score_category_id]
        if score_category_id.nil?
          score_category = ScoreCategory.where(general: true).first
        else
          begin
            score_category = ScoreCategory.find(score_category_id)
          rescue Mongoid::Errors::DocumentNotFound
            return render json: {
                              error: "could not find category with id #{score_category_id}",
                              status: :not_found
                          }, status: :not_found
          end
        end

        thing = score[:thing]

        begin
          thing_validator = ThingValidator.new
          thing_validator.check_validity(thing)
        rescue InvalidThingError => error
          return render json: {
                            error: "thing was invalid: #{error}",
                            status: :bad_request
                        }, status: :bad_request
        end

        begin
          @score = @current_user.score_thing(thing, score_category)
          render template: '/api/v1/scores/create.jbuilder', status: :created, formats: [:json]
        rescue Mongoid::Errors::Validations => error
          return render json: {
                            error: "invalid: #{error}",
                            status: :bad_request
                        }, status: :bad_request
        end
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
