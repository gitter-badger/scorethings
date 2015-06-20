module Api
  module V1
    class ScoresController < ApplicationController
      skip_before_action :authenticate_request, :current_user, only: [:show]

      def create
        score_params = params.require(:score).permit(:points, thing: [:wikidata_item_id])

        begin
          thing = $thing_service.find_thing_or_create_from_wikidata(score_params[:thing][:wikidata_item_id])
          score_params[:thing] = thing

          @score = Score.new(score_params)
          @current_user.create_score(@score)
          return render json: {
                            score: @score,
                            status: :created
                        }, status: :created
        rescue Exceptions::ScoreUniquenessError
          existing_score = @current_user.scores.where(thing: thing).first
          return render json: {
                            error: "a score for this thing has already been created by this user",
                            existing_score: existing_score,
                            status: :conflict
                        }, status: :conflict
        rescue Mongoid::Errors::DocumentNotFound
          return render json: {
                            status: :not_found
                        }, status: :not_found
        rescue Exceptions::WikidataItemNotFoundError
          return render json: {
                            status: :not_found
                        }, status: :not_found
        rescue Mongoid::Errors::Validations
          return render json: {
                            error: "failed to create score: #{@score.errors.full_messages}",
                            status: :bad_request
                        }, status: :bad_request
        end
      end

      def update
        begin
          @score = Score.find(params.require(:id))
          score_params = params.require(:score).permit(:points)
          @current_user.update_score(@score, score_params)
        rescue Mongoid::Errors::DocumentNotFound
          return render json: {
                            status: :not_found
                        }, status: :not_found
        rescue Exceptions::UnauthorizedModificationError
          return render json: {
                            error: "unauthorized, cannot update score",
                            status: :forbidden
                        }, status: :forbidden
        rescue Mongoid::Errors::Validations
          return render json: {
                            error: "failed to update score: #{@score.errors.full_messages}",
                            status: :bad_request
                        }, status: :bad_request
        end
      end

      def destroy
        id = params.require(:id)
        begin
          score = Score.find(id)
          @current_user.delete_score(score)
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