require 'rails_helper'

RSpec.describe AuthTokenController do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)

  describe "POST create" do
    it "should generate an authentication token when a new user authenticates successfully" do
      auth = {
          provider: 'twitter',
          uid: '2121',
          info: OmniAuth::AuthHash::InfoHash.new(nickname: 'alpha')
      }

      request.env['omniauth.auth'] = auth

      user = User.where(twitter_uid: '2121').first
      expect(user).to be_nil
      post :create
      user = User.where(twitter_uid: '2121').first
      expect(user).to_not be_nil

      expect(response).to have_http_status(:ok)
      expect(assigns[:auth_token]).to eq(user.generate_auth_token)
      expect(response).to render_template(:authentication_success)
    end

    it "should generate an authentication token when existing user authenticates successfully" do
      user = create(:user_alpha)
      auth = {
          provider: 'twitter',
          uid: '2121',
          info: OmniAuth::AuthHash::InfoHash.new(nickname: 'alpha')
      }
      request.env['omniauth.auth'] = auth
      post :create

      expect(response).to have_http_status(:ok)
      expect(assigns[:auth_token]).to eq(user.generate_auth_token)
      expect(response).to render_template(:authentication_success)
    end
  end

  it "should not generate an authentication token when new user does not authenticate successfully" do
    OmniAuth.config.mock_auth[:twitter] = :invalid_credentials

    user = User.where(twitter_uid: '2121').first
    expect(user).to be_nil
    post :create
    user = User.where(twitter_uid: '2121').first
    expect(user).to be_nil

    expect(response).to have_http_status(:unauthorized)
    expect(response).to render_template(:authentication_failure)
  end
end
