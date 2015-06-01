module Api
  module V1
    class MeController < ApplicationController
      def show
      end

      def update
        begin
          user_attributes = params.require(:user).permit(:username, :description, :default_points)
          @current_user.update_attributes!(user_attributes)
          redirect_to action: 'show'
        rescue Mongoid::Errors::Validations
          return render json: {
                            error: "cannot update you, errors: #{@current_users.errors.full_messages}",
                            status: :bad_request
                        }, status: :bad_request
        end
      end

      def destroy
        @current_user.destroy!
        return render json: {
                          message: "user has been deleted",
                          status: :ok
                      }, status: :ok
      end
    end
  end
end