class GeneralController < ApplicationController
  skip_before_action :current_user, :authenticate_request
  def index
    @users = User.all
  end
  def about
  end
end
