module Api
  module V1
    class ScoresController < ApplicationController
      skip_before_action :authenticate_request, only: [:show]

      def create
        score_params = params.require(:score).permit(:score_category_id, :thing_id, :points)
        thing_id = score_params[:thing_id]
        score_category_id = score_params[:score_category_id]

        begin
          thing = Thing.find(thing_id)
          if score_category_id.nil?
            # if params did not include score category, or one couldn't be found, use the general one
            score_category = ScoreCategory.find_by(general: true)
          else
            score_category = ScoreCategory.find(score_category_id)
          end
          score_params[:thing] = thing
          score_params[:score_category] = score_category

          @score = Score.new(score_params)
          @current_user.create_score(@score)
          redirect_to action: 'show', id: @score._id.to_s
        rescue Mongoid::Errors::DocumentNotFound
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
          score_params = params.require(:score).permit(:points, :score_category_id)
          @current_user.change_score(@score, score_params)
          redirect_to action: 'show', id: @score._id.to_s
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
