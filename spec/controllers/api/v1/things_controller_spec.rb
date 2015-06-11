require 'rails_helper'

RSpec.describe Api::V1::ThingsController do
  before do
    @user = create(:user)
    auth_token = @user.generate_auth_token.to_s
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
    @thing = Thing.new(
        dbpedia_uri: '249346453',
        type: Scorethings::ThingTypes::TWITTER_ACCOUNT,
        title: '@puddinstrip'
    )
  end

  describe "GET show" do
    it "should find a thing without a thing_reference" do
      allow_any_instance_of(ThingService).to receive(:get_thing).with(@thing.type, @thing.dbpedia_uri)
                                                 .and_return(@thing)
      get :show, {type: @thing.type, dbpedia_uri: @thing.dbpedia_uri}
      expect(response).to have_http_status(:ok)
      expect(assigns(:thing).dbpedia_uri).to eq(@thing.dbpedia_uri)
      expect(assigns(:thing_reference)).to be_nil
    end

    it "should find a thing with a thing_reference" do
      @thing_reference = create(:thing_reference, dbpedia_uri: @thing.dbpedia_uri, type: @thing.type)
      allow_any_instance_of(ThingService).to receive(:get_thing).with(@thing.type, @thing.dbpedia_uri)
                                                 .and_return(@thing)
      get :show, {type: @thing.type, dbpedia_uri: @thing.dbpedia_uri}
      expect(response).to have_http_status(:ok)
      expect(assigns(:thing).dbpedia_uri).to eq(@thing.dbpedia_uri)
      expect(assigns(:thing_reference)).to eq(@thing_reference)
    end

    it "should not find a thing that doesn't exist" do
      allow_any_instance_of(ThingService).to receive(:get_thing).with(@thing.type, @thing.dbpedia_uri)
                                                 .and_raise(Exceptions::PotentialThingNotFoundError)
      get :show, {type: @thing.type, dbpedia_uri: @thing.dbpedia_uri}
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET search" do
    it "should search for a thing_reference" do
      allow_any_instance_of(ThingService).to receive(:search_for_things).with(@thing.type, 'somequery')
                                                 .and_return([@thing])
      get :search_image, {type: @thing.type, query: 'somequery'}
      expect(response).to have_http_status(:ok)
      expect(assigns(:thing_search_results)).to eq([@thing])
    end

    it "should not search with unknown type" do
      allow_any_instance_of(ThingService).to receive(:search_for_things).with('funnycatsthing', 'somequery')
                                                 .and_raise(Exceptions::ThingTypeUnknownError)
      get :search_image, {type: 'funnycatsthing', query: 'somequery'}
      expect(response).to have_http_status(:bad_request)
    end

    it "should search thing reference hashtags" do
      create(:thing_reference, :hashtag, dbpedia_uri: 'ApplePie')
      create(:thing_reference, :hashtag, dbpedia_uri: 'BananaCake')
      create(:thing_reference, :hashtag, dbpedia_uri: 'CherriePie')

      get :search_image, {type: 'hashtag', query: 'Banana'}
      expect(response).to have_http_status(:ok)
      expect(assigns(:thing_search_results).length).to eq(1)

      get :search_image, {type: 'hashtag', query: 'Pie'}
      expect(assigns(:thing_search_results).length).to eq(2)
    end
  end
end
