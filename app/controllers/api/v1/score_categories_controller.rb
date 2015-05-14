module Api
  module V1
    class ScoreCategoriesController < ApplicationController
      # TODO allow unauthenticated read?
      skip_before_action :authenticate_request, :current_user, only: [:index]

      def index
        score_categories = ScoreCategory.all
        render json: {
                   score_categories: score_categories,
                   status: :ok
               }, status: :ok
      end
    end
  end
end