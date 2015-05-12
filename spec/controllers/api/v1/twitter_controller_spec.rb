require 'rails_helper'

RSpec.describe Api::V1::TwitterController do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)

  describe "GET handle_search" do
    it "should search for a twitter account with a twitter handle" do
      allow_any_instance_of(TwitterService).to receive(:search_for_twitter_accounts).with('SomeTwitterUser').and_return([])
      user = create(:user_alpha)
      auth_token = user.generate_auth_token.to_s

      @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
      get :handle_search, {twitter_handle: 'SomeTwitterUser'}

      expect(response).to have_http_status(:ok)
    end

    it "should say bad request if unknown param" do
      user = create(:user_alpha)
      auth_token = user.generate_auth_token.to_s

      @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
      get :handle_search, {instagram_user_handle: 'SomeInstagramUser'}

      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "GET user_info" do
    it "should search for a twitter account with a twitter handle" do
      twitter_account = instance_double("Twitter::User")
      allow_any_instance_of(TwitterService).to receive(:get_twitter_account_from_uid).with(2121).and_return(twitter_account)
      user = create(:user_alpha)
      auth_token = user.generate_auth_token.to_s

      @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
      get :user_info, {twitter_uid: '2121'}

      expect(response).to have_http_status(:ok)
    end

    it "should say not found if twitter account cannot be found" do
      allow_any_instance_of(TwitterService).to receive(:get_twitter_account_from_uid).with(2121).and_return(nil)
      user = create(:user_alpha)
      auth_token = user.generate_auth_token.to_s

      @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
      get :user_info, {twitter_uid: '2121'}

      expect(response).to have_http_status(:not_found)
    end
  end
end
