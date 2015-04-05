class DashboardController < ApplicationController
  skip_before_action :current_user, :authenticate_request
  def index
  end
end
