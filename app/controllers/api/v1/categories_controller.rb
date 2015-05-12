module Api
  module V1
    class CategoriesController < ApplicationController
      # TODO allow unauthenticated read?
      skip_before_action :authenticate_request, :current_user, only: [:index]

      def index
        categories = Category.all
        render json: {
                   categories: categories,
                   status: :ok
               }, status: :ok
      end
    end
  end
end