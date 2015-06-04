require 'rails_helper'

RSpec.describe Api::V1::SettingsController do
  before do
    @user = create(:user)
    @settings = create(:settings, user: @user)
    auth_token = @user.generate_auth_token.to_s
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
  end

  describe "GET show" do
    it "should show user settings settings" do
      get :show
      expect(response).to have_http_status(:ok)
      expect(assigns(:settings)).to_not be_nil
      expect(assigns(:settings)).to eq(@settings)
    end
  end

  describe "PUT update" do
    it "should update user settings" do
      @user.settings.default_points = 40
      expect(@user.settings.default_points).to eq(40)

      put :update, {settings: {default_points: 50}}
      @user.reload
      expect(@user.settings.default_points).to eq(50)
    end

    it "should not allow update with invalid" do
      @user.settings.default_points = 40
      expect(@user.settings.default_points).to eq(40)

      put :update, {settings: {default_points: 104}}
      expect(response).to have_http_status(:bad_request)

      expect(@user.settings.default_points).to eq(40)
    end

    it "should not update account if unauthorized" do
      @request.env['HTTP_AUTHORIZATION'] = ''

      put :update, {settings: {default_points: 50}}
      expect(response).to have_http_status(:unauthorized)

      @user.reload
      expect(@user.settings.default_points).to_not eq(50)
    end
  end
end
