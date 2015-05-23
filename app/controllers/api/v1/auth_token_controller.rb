module Api
  module V1
    class AuthTokenController < ApplicationController
      skip_before_action :authenticate_request, :current_user

      def create
        auth = request.env['omniauth.auth']

        begin
          user = User.find_by_omniauth(auth)
          if user.nil?
            user = User.create_with_omniauth(auth)
          end
          @auth_token = user.generate_auth_token
          respond_to do |format|
            format.html { render 'auth_token/authentication_success' }
            format.json { head :ok, json: @auth_token }
          end
        rescue Exceptions::AuthenticationFailureError
          return respond_unauthorized
        end
      end

      private
      def respond_unauthorized
        respond_to do |format|
          format.html { render 'auth_token/authentication_failure', status: :unauthorized }
          format.json { head :unauthorized }
        end
      end
    end
  end
end
