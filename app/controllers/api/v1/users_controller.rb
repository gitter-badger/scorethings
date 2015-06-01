module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate_request, :current_user, only: [:show, :search]

      def show
        begin
          @user = User.find(params.require(:id))
        rescue Mongoid::Errors::DocumentNotFound
          return render json: {
                            error: "cannot find user",
                            status: :not_found
                        }, status: :not_found
        end
      end

      def search
        query = params[:query]
        @users = User.full_text_search(query)
      end
    end
  end
end