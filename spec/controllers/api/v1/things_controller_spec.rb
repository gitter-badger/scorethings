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
      params = {
         thing: {
             external_id: '111',
             type: Scorethings::ThingTypes::TWITTER_ACCOUNT
         }
      }
      thing = build(:thing, :twitter_account, external_id: '111')

      allow_any_instance_of(ThingService).to receive(:load_external_thing).with(Scorethings::ThingTypes::TWITTER_ACCOUNT, '111')
                                                 .and_return(thing)
      post :create, params
      expect(response).to have_http_status(:created)
      expect(assigns(:thing)).to_not be_nil
    end
  end

  describe "GET find to get a thing model by it's thing_type and external_id" do
    # FIXME there may be confusion over the fact that this url will return Thing models, but
    # not persisted models, generated ones with data from the external apis,
    # should probably create a seperate model(non persistent) to clear things up (ExternalThing ?)
    before do
      @user = create(:user_alpha)
      auth_token = @user.generate_auth_token.to_s
      @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
      @thing = create(:thing, :twitter_account)
    end

    it "should find a thing if it exists" do
      get :find, {thing_type: 'twitter_account', external_id: @thing.external_id}
      expect(response).to have_http_status(:ok)
      expect(assigns(:thing)).to eq(@thing)
    end

    it "should not find a thing if it does not exist" do
      get :find, {thing_type: 'twitter_account', external_id: "111#{@thing.external_id}"}
      expect(response).to have_http_status(:not_found)
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

  describe "GET thing scores" do
    before do
      @user = create(:user_alpha)
      auth_token = @user.generate_auth_token.to_s
      @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
    end

    it "should get all of the scores for a thing" do
      thing_1 = create(:thing, :hashtag)
      thing_2 = create(:thing, :twitter_account)

      score_1 = @user.create_score(Score.new(thing: thing_1, score_category: create(:score_category)))
      score_2 = @user.create_score(Score.new(thing: thing_2, score_category: create(:score_category)))
      score_3 = @user.create_score(Score.new(thing: thing_2, score_category: create(:score_category)))

      get :scores, {thing_id: thing_1._id.to_s}
      expect(response).to have_http_status(:ok)
      expect(assigns(:thing).scores).to eq([score_1])

      get :scores, {thing_id: thing_2._id.to_s}
      expect(response).to have_http_status(:ok)
      expect(assigns(:thing).scores).to eq([score_2, score_3])
    end
  end
end
