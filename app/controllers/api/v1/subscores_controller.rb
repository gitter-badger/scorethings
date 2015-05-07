module Api
  module V1
    class SubscoresController < ApplicationController
      def create
        score = Score.where(id: params[:score_id]).first
        if score.nil?
          return render json: {
                            error: "could not find score to add subscore to",
                            status: :bad_request
                        }, status: :bad_request
        end

        criterion = Criterion.where(id: params[:criterion_id]).first
        if criterion.nil?
          return render json: {
                            error: "could not find criterion to use for subscore",
                            status: :bad_request
                        }, status: :bad_request
        end

        if score.user._id != @current_user._id
          return render json: {
                            error: "only a score's user can add a subscore to it",
                            status: :unauthorized
                        }, status: :unauthorized
        end

        subscore = @current_user.add_or_change_subscore(score, criterion, params[:value])
        return render json: {
                          subscore: subscore,
                          status: :created
                      }, status: :created
      end

      def update

      end
    end
  end
end