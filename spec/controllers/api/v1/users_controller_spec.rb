require 'rails_helper'

RSpec.describe Api::V1::UsersController do
  before do
    @user = create(:user)
    @other_user = create(:user)
    auth_token = @user.generate_auth_token.to_s
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
  end

  describe "GET show" do
    it "should get a user via username" do
      get :show, {username: @user.username}
      expect(response).to have_http_status(:ok)
      expect(assigns(:user)).to eq(@user)
    end

    it "should get a user via id" do
      get :show, {id: @user._id}
      expect(response).to have_http_status(:ok)
      expect(assigns(:user)).to eq(@user)
    end

    it "should get another user" do
      get :show, {username: @other_user.username}
      expect(response).to have_http_status(:ok)
      expect(assigns(:user)).to eq(@other_user)
    end

    it "should not find a user" do
      get :show, {username: '123notausername'}
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET search" do
    before do
      @user_a = create(:user, username: 'alpha')
      @user_b = create(:user, username: 'bravo')
      @user_c = create(:user, username: 'charlie')
      @user_d = create(:user, username: 'delta')
    end

    it "should search for a single user with username" do
      get :search, {query: 'alpha'}

      expect(response).to have_http_status(:ok)
      expect(assigns(:users)).to eq([@user_a])
    end
  end

  describe "PUT update" do
    it "should update account" do
      expect(@user.username).to_not eq('diggity')

      put :update, {user: {username: 'diggity'}}
      @user.reload
      expect(@user.username).to eq('diggity')
    end

    it "should not update account if unauthorized" do
      @request.env['HTTP_AUTHORIZATION'] = ''

      expect(@user.username).to_not eq('diggity')

      put :update, {user: {username: 'diggity'}}
      expect(response).to have_http_status(:unauthorized)

      @user.reload
      expect(@user.username).to_not eq('diggity')
      # no doubt
    end
  end

  describe "DELETE destroy" do
    it "should destroy user" do
      # FIXME read Asimov's README to prevent user harm
      expect(User.where(id: @user._id).length).to eq(1)
      delete :destroy
      expect(response).to have_http_status(:ok)
      expect(User.where(id: @user._id).length).to eq(0)
    end
  end
end
