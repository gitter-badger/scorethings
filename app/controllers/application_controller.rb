class ApplicationController < ActionController::Base
  before_action :current_user, :authenticate_request

  # copied from
  # http://railsapps.github.io/tutorial-rails-mongoid-omniauth.html
  helper_method :current_user

  rescue_from Exceptions::NotAuthenticatedError do
    render json: {
               error: 'Not Authorized'
           },
           status: :unauthorized
  end

  private
  def current_user
    begin
      dat = decoded_auth_token
      if dat.nil?
        return User.none
      end
      user_id = dat[:user_id]
      @current_user ||= User.find(user_id)
    rescue Mongoid::Errors::DocumentNotFound
      User.none
    end
  end

  def authenticate_request
    if auth_token_expired?
      fail Exceptions::AuthenticationTimeoutError
    elsif !@current_user
      fail Exceptions::NotAuthenticatedError
    end
  end

  def decoded_auth_token
    @decoded_auth_token ||= AuthToken.decode(http_auth_header_content)
  end

  def auth_token_expired?
    decoded_auth_token && decoded_auth_token.expired?
  end

  def http_auth_header_content
    # JWT format example:
    # somerandomstring.encoded-payload.anotherrandomstring
    #
    return @http_auth_header_content if defined? @http_auth_header_content
    @http_auth_header_content = begin
      if request.headers['Authorization'].present?
        request.headers['Authorization'].split(' ').last
      else
        nil
      end
    end
  end
end
