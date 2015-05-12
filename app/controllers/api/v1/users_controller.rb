module Api
  module V1
    class UsersController < ApplicationController
      def current_user_info
        # FIXME this should be moved into a general user info, not just current user info
        @user = User.where(id: @current_user.id).first
        if @user.nil?
          # besides, if the current user cannot be found, this won't be reached, because the request won't pass
          # authentication (wait, I think, bugs could be introduced in future)
          # whatever, still move to users#show, have a more private action for account/private information
          # this is just to see the scores, criteria, etc. that the user owns
            return render json: {
                         error: "could not current_user_info",
                         status: :not_found
                     }, status: :not_found
        end
      end

      def criteria
        user_id = params[:id]
        user = User.where(id: user_id).first
        if user.nil?
          return render json: {
                            error: "could not current_user_info",
                            status: :not_found
                        }, status: :not_found
        end

        @criteria = user.criteria
      end
    end
  end
end
