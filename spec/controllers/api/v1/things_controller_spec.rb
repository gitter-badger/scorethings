require 'rails_helper'

RSpec.describe Api::V1::ThingsController do
  before do
    @user = create(:user_alpha)
    auth_token = @user.generate_auth_token.to_s
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
  end

  describe "POST create" do
    before do
      @thing = build(:thing, :twitter_account)
      @web_thing = WebThing.new(
          external_id: @thing.external_id,
          type: @thing.type
      )
      @create_params = {
        thing: {
          external_id: @thing.external_id,
          type: @thing.type
        }
      }

    end

    it "should create a thing" do
      allow_any_instance_of(ThingService).to receive(:get_web_thing).with(@thing.type, @thing.external_id)
                                                 .and_return(@web_thing)
      expect(Thing.all.length).to eq(0)
      post :create, @create_params
      expect(Thing.all.length).to eq(1)
      expect(assigns(:thing)).to_not be_nil
      expect(assigns(:thing)).to eq(Thing.all.first)
      expect(response).to redirect_to :action => :show, id: assigns(:thing)._id.to_s
    end

    it "should not create a thing without web_thing" do
      allow_any_instance_of(ThingService).to receive(:get_web_thing).with(@web_thing.type, @web_thing.external_id)
                                                 .and_raise(Exceptions::WebThingNotFoundError)
      post :create, @create_params
      expect(response).to have_http_status(:not_found)
    end

    it "should not create a thing if not authenticated" do
      @request.env['HTTP_AUTHORIZATION'] = ''
      post :create, @create_params
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET show" do
    before do
      @created_thing = create(:thing, :twitter_account)
      @web_thing = WebThing.new(
          external_id: @created_thing.external_id,
          type: @created_thing.type
      )
    end

    it "should show a thing with a web_thing" do
      allow_any_instance_of(ThingService).to receive(:get_web_thing).with(@created_thing.type, @created_thing.external_id)
                                                 .and_return(@web_thing)
      get :show, {id: @created_thing}
      expect(response).to have_http_status(:ok)
      expect(assigns(:thing)).to eq(@created_thing)
      expect(assigns(:web_thing)).to eq(@web_thing)
    end

    it "should not show a thing that doesn't exist" do
      get :show, {id: '123notavailable'}
      expect(response).to have_http_status(:not_found)
    end

    it "should not show a thing that doesn't have a web thing" do
      allow_any_instance_of(ThingService).to receive(:get_web_thing).with(@web_thing.type, @web_thing.external_id)
                                                 .and_raise(Exceptions::WebThingNotFoundError)
      get :show, {id: @created_thing}
      expect(response).to have_http_status(:failed_dependency)
    end
  end
end
