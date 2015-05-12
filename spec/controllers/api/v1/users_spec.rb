require 'rails_helper'

RSpec.describe Api::V1::UsersController do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)
  before do
    @user = create(:user_alpha)
    auth_token = @user.generate_auth_token.to_s
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
  end

  describe "GET show" do
    it "should show the current user info" do
      get :current_user_info
      expect(response).to have_http_status(:ok)
    end

    it "should say current user info can't be found if user can't be found" do
      @user.destroy
      get :current_user_info
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET criteria" do
    it "should show the criteria that belongs to a user" do
      create_list(:positive_criterion, 2, user: @user)

      get :criteria, {id: @user._id.to_s}
      expect(response).to have_http_status(:ok)
    end
  end
end
