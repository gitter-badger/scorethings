module Api
  module V1
    class UsersController < ApplicationController
      # TODO allow unauthenticated read?
      skip_before_action :authenticate_request, :current_user, only: [:scores]

      def scores
        user = user_from_params
        @scores = user.scores
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