require 'rails_helper'

RSpec.describe Api::V1::UsersController do
  before do
    @user = create(:user)
    @other_user = create(:user)
    auth_token = @user.generate_auth_token.to_s
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
  end

  describe "GET show" do
    it "should get a user" do
      get :show, {id: @user._id}
      expect(response).to have_http_status(:ok)
      expect(assigns(:user)).to eq(@user)
    end

    it "should get another user" do
      get :show, {id: @other_user._id}
      expect(response).to have_http_status(:ok)
      expect(assigns(:user)).to eq(@other_user)
    end

    it "should not find a user" do
      get :show, {id: '123notauserid'}
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET search" do
    before do
      @user_a = create(:user, username: 'alpha', description: 'I like eating apples')
      @user_b = create(:user, username: 'bravo', description: 'I like eating bananas')
      @user_c = create(:user, username: 'charlie', description: 'I like eating cherries')
      @user_d = create(:user, username: 'delta', description: 'I like drinking smoothies')
    end

    it "should search for a single user with username" do
      get :search, {query: 'alpha'}

      expect(response).to have_http_status(:ok)
      expect(assigns(:users)).to eq([@user_a])
    end

    it "should search for a several users with description" do
      get :search, {query: 'eating'}

      expect(response).to have_http_status(:ok)
      expect(assigns(:users)).to eq([@user_a, @user_b, @user_c])
    end
  end
end
