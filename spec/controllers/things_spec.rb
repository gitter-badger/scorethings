require 'rails_helper'

RSpec.describe ThingsController do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)

  describe "GET lists" do
    it "should search for a twitter account with a twitter handle" do
      allow_any_instance_of(TwitterService).to receive(:search_for_twitter_accounts).and_return([])
      user = create(:user_alpha)
      auth_token = user.generate_auth_token.to_s

      @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
      get :search, {twitter_handle: 'SomeTwitterUser'}

      expect(response).to have_http_status(:ok)
    end

    it "should say bad request if unknown criteria" do
      user = create(:user_alpha)
      auth_token = user.generate_auth_token.to_s

      @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
      get :search, {instagram_user_handle: 'SomeInstagramUser'}

      expect(response).to have_http_status(:bad_request)
    end
  end
end
