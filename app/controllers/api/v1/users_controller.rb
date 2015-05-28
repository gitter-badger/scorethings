module Api
  module V1
    class UsersController < ApplicationController
      def show
        @user = user_from_params
      end

      def search
        query = params[:query]
        @scores = User.full_text_search(query)
      end

      def user_from_params
        user_id = params[:id]
        begin
          User.find(user_id)
        rescue Mongoid::Errors::DocumentNotFound
          render json: {
                     error: "could not find user with id #{user_id}",
                     status: :not_found
                 }, status: :not_found
        end
      end
    end
  end
end