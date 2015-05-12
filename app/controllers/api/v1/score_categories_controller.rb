module Api
  module V1
    class ScoreCategoriesController < ApplicationController
      def create
        # FIXME add nested strong params for score_category: {:value, :category_id}
        score_category_input = params.require(:score_category).permit(:points, :category_id)

        score = Score.where(id: params[:id]).first
        if score.nil?
          return render json: {
                            error: "could not find score to add score category to",
                            status: :not_found
                        }, status: :not_found
        end

        category = Category.where(id: score_category_input[:category_id]).first
        if category.nil?
          return render json: {
                            error: "could not find category to use to for score category",
                            status: :not_found
                        }, status: :not_found
        end

        begin
          @score_category = @current_user.add_score_category(score, category, score_category_input[:points])
          # TODO create jbuilder?
          return render json: {
                            score_category: @score_category,
                            status: :created
                        }, status: :created
        rescue UnauthorizedModificationError
          return render json: {
                            error: "could not add score category to score",
                            status: :forbidden
                        }, status: :forbidden
        rescue ScoreCategoryRedundancyError
          return render json: {
                            error: "a score category with that category already exists",
                            status: :conflict
                        }, status: :conflict

          # TODO handle validation errors (points not between 1 and 100, etc.)
        end
      end
    end
  end
end