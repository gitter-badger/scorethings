class AuthTokenController < ApplicationController
  skip_before_action :authenticate_request

  def create
    auth = request.env['omniauth.auth']
    user = User.where(twitterUid: auth['uid']).first || User.create_with_omniauth(auth)

    if user
      @auth_token = user.generate_auth_token
      render 'authentication_success'
    else
      render 'authentication_error'
    end
  end
end