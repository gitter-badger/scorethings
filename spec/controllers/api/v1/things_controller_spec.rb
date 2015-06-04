require 'rails_helper'

RSpec.describe Api::V1::ThingsController do
  before do
    @user = create(:user)
    auth_token = @user.generate_auth_token.to_s
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
    @thing = Thing.new(
        external_id: '249346453',
        type: Scorethings::ThingTypes::TWITTER_ACCOUNT,
        title: '@puddinstrip'
    )
  end

  describe "GET show" do
    it "should find a thing without a thing_reference" do
      allow_any_instance_of(ThingService).to receive(:get_thing).with(@thing.type, @thing.external_id)
                                                 .and_return(@thing)
      get :show, {type: @thing.type, external_id: @thing.external_id}
      expect(response).to have_http_status(:ok)
      expect(assigns(:thing).external_id).to eq(@thing.external_id)
      expect(assigns(:thing_reference)).to be_nil
    end

    it "should find a thing with a thing_reference" do
      @thing_reference = create(:thing_reference, external_id: @thing.external_id, type: @thing.type)
      allow_any_instance_of(ThingService).to receive(:get_thing).with(@thing.type, @thing.external_id)
                                                 .and_return(@thing)
      get :show, {type: @thing.type, external_id: @thing.external_id}
      expect(response).to have_http_status(:ok)
      expect(assigns(:thing).external_id).to eq(@thing.external_id)
      expect(assigns(:thing_reference)).to eq(@thing_reference)
    end

    it "should not find a thing that doesn't exist" do
      allow_any_instance_of(ThingService).to receive(:get_thing).with(@thing.type, @thing.external_id)
                                                 .and_raise(Exceptions::ThingNotFoundError)
      get :show, {type: @thing.type, external_id: @thing.external_id}
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET search" do
    it "should search for a thing_reference" do
      allow_any_instance_of(ThingService).to receive(:search_for_things).with(@thing.type, 'somequery')
                                                 .and_return([@thing])
      get :search, {type: @thing.type, query: 'somequery'}
      expect(response).to have_http_status(:ok)
      expect(assigns(:thing_search_results)).to eq([@thing])
    end

    it "should not search with unknown type" do
      allow_any_instance_of(ThingService).to receive(:search_for_things).with('funnycatsthing', 'somequery')
                                                 .and_raise(Exceptions::ThingTypeUnknownError)
      get :search, {type: 'funnycatsthing', query: 'somequery'}
      expect(response).to have_http_status(:bad_request)
    end
  end
end
