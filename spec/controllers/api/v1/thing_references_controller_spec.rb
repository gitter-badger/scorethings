require 'rails_helper'

RSpec.describe Api::V1::ThingReferencesController do
  before do
    @user = create(:user)
    auth_token = @user.generate_auth_token.to_s
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
  end

  describe "POST create" do
    before do
      @thing_reference = build(:thing_reference, :twitter_account)
      @thing = Thing.new(
          external_id: @thing_reference.external_id,
          type: @thing_reference.type
      )
      @create_params = {
        thing_reference: {
          external_id: @thing_reference.external_id,
          type: @thing_reference.type
        }
      }

    end

    it "should create a thing_reference" do
      allow_any_instance_of(ThingService).to receive(:get_thing).with(@thing_reference.type, @thing_reference.external_id)
                                                 .and_return(@thing)
      expect(ThingReference.all.length).to eq(0)
      post :create, @create_params
      expect(ThingReference.all.length).to eq(1)
      expect(assigns(:thing_reference)).to_not be_nil
      expect(assigns(:thing_reference)).to eq(ThingReference.all.first)
      expect(response).to redirect_to :action => :show, id: assigns(:thing_reference)._id.to_s
    end

    it "should not create a thing_reference without thing" do
      allow_any_instance_of(ThingService).to receive(:get_thing).with(@thing.type, @thing.external_id)
                                                 .and_raise(Exceptions::ThingNotFoundError)
      post :create, @create_params
      expect(response).to have_http_status(:not_found)
    end

    it "should not create a thing_reference if not authenticated" do
      @request.env['HTTP_AUTHORIZATION'] = ''
      post :create, @create_params
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET show" do
    before do
      @created_thing = create(:thing_reference, :twitter_account)
      @thing = Thing.new(
          external_id: @created_thing.external_id,
          type: @created_thing.type
      )
    end

    it "should show a thing_reference with a thing" do
      allow_any_instance_of(ThingService).to receive(:get_thing).with(@created_thing.type, @created_thing.external_id)
                                                 .and_return(@thing)
      get :show, {id: @created_thing}
      expect(response).to have_http_status(:ok)
      expect(assigns(:thing_reference)).to eq(@created_thing)
      expect(assigns(:thing)).to eq(@thing)
    end

    it "should not show a thing_reference that doesn't exist" do
      get :show, {id: '123notavailable'}
      expect(response).to have_http_status(:not_found)
    end

    it "should not show a thing_reference that doesn't have a thing" do
      allow_any_instance_of(ThingService).to receive(:get_thing).with(@thing.type, @thing.external_id)
                                                 .and_raise(Exceptions::ThingNotFoundError)
      get :show, {id: @created_thing}
      expect(response).to have_http_status(:failed_dependency)
    end
  end
end
