require 'rails_helper'

RSpec.describe Api::V1::AuthTokenController do
  describe "POST create" do
    before do
      @auth = {
          provider: 'twitter',
          uid: '2121',
          info: OmniAuth::AuthHash::InfoHash.new(nickname: 'alpha')
      }

      request.env['omniauth.auth'] = @auth
    end

    it "should generate an authentication token when a new user authenticates successfully" do
      expect(User.all.length).to eq(0)
      post :create
      expect(User.all.length).to eq(1)

      expect(response).to have_http_status(:ok)
      expect(assigns[:auth_token]).to_not be_nil
      expect(response).to render_template(:authentication_success)
    end

    it "should generate an authentication token when existing user authenticates successfully" do
      User.create_with_omniauth(@auth)
      expect(User.all.length).to eq(1)
      post :create
      expect(User.all.length).to eq(1)

      expect(response).to have_http_status(:ok)
      expect(assigns[:auth_token]).to_not be_nil
      expect(response).to render_template(:authentication_success)
    end
  end

  it "should not generate an authentication token when new user does not authenticate successfully" do
    OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
    expect(User.all.length).to eq(0)
    post :create
    expect(User.all.length).to eq(0)

    expect(response).to have_http_status(:unauthorized)
    expect(response).to render_template(:authentication_failure)
  end
end
