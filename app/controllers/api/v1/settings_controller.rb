module Api
  module V1
    class SettingsController < ApplicationController
      def update
        begin
          settings_attributes = params.require(:settings).permit(:default_points, :default_good)

          @current_user.settings.update_attributes!(settings_attributes)
          @settings = @current_user.settings
        rescue Mongoid::Errors::Validations
          return render json: {
                            error: "cannot update profile, errors: #{@current_user.settings.errors.full_messages}",
                            status: :bad_request
                        }, status: :bad_request
        end
      end

      def show
        @settings = @current_user.settings
      end
    end
  end
end