class DashboardController < ApplicationController
  skip_before_action :current_user, :authenticate_request

  def index
    @score_categories = ScoreCategory.generate_score_categories_map
  end
end