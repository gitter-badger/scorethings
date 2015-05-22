module Api
  module V1
    class ScoreCategoriesController < ApplicationController
      # TODO allow unauthenticated read?
      skip_before_action :authenticate_request, :current_user, only: [:index]

      def index
        @score_categories = ScoreCategory.generate_score_categories_map
      end
    end
  end
end