module Api
  module V1
    class ScoresController < ApplicationController
      skip_before_action :authenticate_request, only: [:show]

      def create
        score = params.require(:score).permit(:points, :category_id, {:thing => [:type, :value]})
        category = nil
        category_id = score[:category_id]
        begin
          category = Category.find(category_id)
        rescue Mongoid::Errors::DocumentNotFound
          return render json: {
                            error: "could not find category with id #{category_id}",
                            status: :not_found
                        }, status: :not_found
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
          @score = @current_user.score_thing(thing, category)

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
          score_params = params.require(:score).permit(:points, :category_id)
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
