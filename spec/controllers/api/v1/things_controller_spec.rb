require 'rails_helper'

RSpec.describe Api::V1::ThingsController do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)

  describe "POST create" do
    before do
      @user = create(:user_alpha)
      auth_token = @user.generate_auth_token.to_s
      @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
    end

    it "should create a twitter account thing" do
      # post thing with just external id and type
      post_data = {
         thing: {
             external_id: '111',
             type: Scorethings::ThingTypes::TWITTER_ACCOUNT
         }
      }
      thing = build(:thing, :twitter_account, external_id: '111')

      allow_any_instance_of(ThingService).to receive(:find_external_thing).with(Scorethings::ThingTypes::TWITTER_ACCOUNT, '111')
                                                 .and_return(thing)
      post :create, post_data
      expect(response).to have_http_status(:created)
      expect(assigns(:thing)).to_not be_nil
    end
  end

  describe "GET search" do
    before do
      @user = create(:user_alpha)
      auth_token = @user.generate_auth_token.to_s
      @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
      @things = build_list(:thing, 2)
    end
    it "should search for a twitter account" do
      allow_any_instance_of(ThingService).to receive(:search).with('twitter_account', 'SomeTwitterUser').and_return(@things)
      get :search, {thing_type: 'twitter_account', query: 'SomeTwitterUser'}
      expect(response).to have_http_status(:ok)
      expect(assigns(:things)).to eq(@things)
    end

    it "should search for a youtube video" do
      allow_any_instance_of(ThingService).to receive(:search).with('youtube_video', 'Something about cats').and_return(@things)
      get :search, {thing_type: 'youtube_video', query: 'Something about cats'}
      expect(response).to have_http_status(:ok)
      expect(assigns(:things)).to eq(@things)
    end

    it "should search for a twitter tweet" do
      allow_any_instance_of(ThingService).to receive(:search).with('twitter_tweet', 'Something about cats').and_return(@things)
      get :search, {thing_type: 'twitter_tweet', query: 'Something about cats'}
      expect(response).to have_http_status(:ok)
      expect(assigns(:things)).to eq(@things)
    end

    it "should say bad request if unknown thing type param" do
      get :search, {thing_type: 'instagram_account', query: 'SomeUser'}
      expect(response).to have_http_status(:bad_request)
    end
  end
end
