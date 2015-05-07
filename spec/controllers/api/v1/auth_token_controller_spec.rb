require 'rails_helper'

RSpec.describe Api::V1::AuthTokenController do
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
      # I don't think it should test content of auth_token
      # if so, not comparing the whole auth token, because the expiration date will be a different time
      # due to the speed of light traveling to your eyes (jk, Time.now is used in controller)
      # as long as it was assigned, I think that's good enough for controller spec
      expect(assigns[:auth_token]).to_not be_nil
      expect(response).to render_template(:authentication_success)
    end

    it "should generate an authentication token when existing user authenticates successfully" do
      create(:user_alpha)
      auth = {
          provider: 'twitter',
          uid: '2121',
          info: OmniAuth::AuthHash::InfoHash.new(nickname: 'alpha')
      }
      request.env['omniauth.auth'] = auth
      post :create

      expect(response).to have_http_status(:ok)
      expect(assigns[:auth_token]).to_not be_nil
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

    expect(assigns[:auth_token]).to be_nil
    expect(response).to have_http_status(:unauthorized)
    expect(response).to render_template(:authentication_failure)
  end
end
