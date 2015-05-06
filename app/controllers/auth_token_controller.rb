class AuthTokenController < ApplicationController
  skip_before_action :authenticate_request

  def create
    auth = request.env['omniauth.auth']
    if auth.nil?
      return render status: :unauthorized, template: 'auth_token/authentication_failure'
    end

    user = User.where(twitter_uid: auth['uid']).first || User.create_with_omniauth(auth)

    if user
      @auth_token = user.generate_auth_token
      return render status: :ok, template: 'auth_token/authentication_success'
    else
      return render status: :unauthorized, template: 'auth_token/authentication_failure'
    end
  end
end