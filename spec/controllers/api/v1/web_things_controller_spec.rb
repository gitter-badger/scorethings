require 'rails_helper'

RSpec.describe Api::V1::WebThingsController do
  before do
    @user = create(:user_alpha)
    auth_token = @user.generate_auth_token.to_s
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
    @web_thing = WebThing.new(
        external_id: '249346453',
        type: Scorethings::ThingTypes::TWITTER_ACCOUNT,
        title: '@puddinstrip'
    )
  end

  describe "GET show" do
    it "should find a web_thing without a thing" do
      allow_any_instance_of(ThingService).to receive(:get_web_thing).with(@web_thing.type, @web_thing.external_id)
                                                 .and_return(@web_thing)
      get :show, {type: @web_thing.type, external_id: @web_thing.external_id}
      expect(response).to have_http_status(:ok)
      expect(assigns(:web_thing).external_id).to eq(@web_thing.external_id)
      expect(assigns(:web_thing).thing).to be_nil
    end

    it "should find a web_thing with a thing" do
      @thing_for_web_thing = create(:thing, external_id: @web_thing.external_id, type: @web_thing.type)
      allow_any_instance_of(ThingService).to receive(:get_web_thing).with(@web_thing.type, @web_thing.external_id)
                                                 .and_return(@web_thing)
      get :show, {type: @web_thing.type, external_id: @web_thing.external_id}
      expect(response).to have_http_status(:ok)
      expect(assigns(:web_thing).external_id).to eq(@web_thing.external_id)
      expect(assigns(:web_thing).thing).to eq(@thing_for_web_thing)
    end

    it "should not find a web_thing that doesn't exist" do
      allow_any_instance_of(ThingService).to receive(:get_web_thing).with(@web_thing.type, @web_thing.external_id)
                                                 .and_raise(Exceptions::WebThingNotFoundError)
      get :show, {type: @web_thing.type, external_id: @web_thing.external_id}
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET search" do
    it "should search for a thing" do
      allow_any_instance_of(ThingService).to receive(:search_for_web_things).with(@web_thing.type, 'somequery')
                                                 .and_return([@web_thing])
      get :search, {type: @web_thing.type, query: 'somequery'}
      expect(response).to have_http_status(:ok)
      expect(assigns(:web_thing_search_results)).to eq([@web_thing])
    end

    it "should not search with unknown type" do
      allow_any_instance_of(ThingService).to receive(:search_for_web_things).with('funnycatsthing', 'somequery')
                                                 .and_raise(Exceptions::ThingTypeUnknownError)
      get :search, {type: 'funnycatsthing', query: 'somequery'}
      expect(response).to have_http_status(:bad_request)
    end
  end
end
