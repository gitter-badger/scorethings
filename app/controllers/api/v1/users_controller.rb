module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate_request, :current_user, only: [:show, :search]

      def show
        begin
          username_param = params[:username]
          if username_param.nil?
            user_id = params.require(:id)
            @user = User.find(user_id)
          else
            @user = User.find_by(username: username_param)
          end
        rescue Mongoid::Errors::DocumentNotFound
          return render json: {
                            error: "cannot find user",
                            status: :not_found
                        }, status: :not_found
        end
      end

      def current

      end

      def update
        begin
          @current_user.update_attributes!(params.require(:user).permit(:username, :description))
           return render json: {
                             user: @current_user.to_builder,
                             status: :ok
                         }, status: :ok
        rescue Mongoid::Errors::Validations
          return render json: {
                            error: "cannot update, errors: #{@current_users.errors.full_messages}",
                            status: :bad_request
                        }, status: :bad_request
        end
      end

      def search
        query = params[:query]
        @users = User.full_text_search(query)
      end

      def destroy
        @current_user.destroy!
        return render json: {
                          status: :ok
                      }, status: :ok
      end
    end
  end
end