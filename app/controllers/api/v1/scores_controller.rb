module Api
  module V1
    class ScoresController < ApplicationController
      skip_before_action :authenticate_request, only: [:show]

      def create
        score_params = params.require(:score).permit(:points, :score_category_id,
          :thing => [:type, :display_value, :external_id])

        thing_params = score_params[:thing]
        thing = Thing.new(thing_params)
        if !thing.valid?
          # TODO this handles invalidation and twitter account not found,
          # refactor to seperate and give more detailed error messages
          return render json: {
                            error: "failed to determine thing from params: #{thing.errors}",
                            status: :bad_request
                        }, status: :bad_request
        end

        score_category = ScoreCategory.where(id: score_params[:score_category_id]).first
        if score_category.nil?
          # if params did not include score category, use the general one
          score_category = ScoreCategory.where(general: true).first
        end

        score_params.delete(:thing)

        score = Score.new(score_params)
        score.thing = thing
        score.score_category = score_category

        begin
          @score = @current_user.create_score(score)
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
