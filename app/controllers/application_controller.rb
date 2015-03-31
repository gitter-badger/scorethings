class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :current_user, :authenticate_request

  # copied from
  # http://railsapps.github.io/tutorial-rails-mongoid-omniauth.html
  helper_method :current_user
  helper_method :user_signed_in?
  helper_method :correct_user?

  rescue_from NotAuthenticatedError do
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
      fail AuthenticationTimeoutError
    elsif !@current_user
      fail NotAuthenticatedError
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


  def user_signed_in?
    return true if current_user
  end

  #DEPRECATED?
  def correct_user?
    @user = User.find(params[:id])
    unless current_user == @user
      redirect_to root_url, :alert => "Access denied."
    end
  end

  #DEPRECATED?
  def authenticate_user!
    if !current_user
      redirect_to root_url, :alert => 'You need to sign in for access to this page.'
    end
  end
end
