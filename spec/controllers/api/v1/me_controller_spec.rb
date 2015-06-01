require 'rails_helper'

RSpec.describe Api::V1::MeController do
  before do
    @user = create(:user)
    auth_token = @user.generate_auth_token.to_s
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
  end

  describe "GET show" do
    it "should show me" do
      get :show
      expect(response).to have_http_status(:ok)
      expect(assigns(:current_user)).to eq(@user)
    end

    it "should not show me if not authenticated" do
      @request.env['HTTP_AUTHORIZATION'] = ''
      get :show
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "PUT update" do
    it "should update me" do
      expect(@user.username).to_not eq('diggity')

      put :update, {user: {username: 'diggity'}}
      @user.reload
      expect(@user.username).to eq('diggity')
    end

    it "should not update me if unauthorized" do
      @request.env['HTTP_AUTHORIZATION'] = ''

      expect(@user.username).to_not eq('diggity')

      put :update, {user: {username: 'diggity'}}
      expect(response).to have_http_status(:unauthorized)

      @user.reload
      # no diggity, no doubt
      expect(@user.username).to_not eq('diggity')
    end
  end

  describe "DELETE destroy" do
    it "should destroy me" do
      expect(User.where(id: @user._id).length).to eq(1)
      delete :destroy
      expect(response).to have_http_status(:ok)
      expect(User.where(id: @user._id).length).to eq(0)
    end
  end
end
