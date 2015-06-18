require 'rails_helper'

RSpec.describe Api::V1::ThingsController do
  before do
    @user = create(:user)
    auth_token = @user.generate_auth_token.to_s
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
    @params = {
        thing: {
            resource_name: 'Patton_Oswalt'
        }
    }
    @thing = create(:thing, resource_name: 'Patton_Oswalt', label: 'Patton Oswalt')
  end

  describe "POST create" do
    it "should create a new thing" do
      expect_any_instance_of(ThingService).to receive(:find_or_create_thing_from_dbpedia).with('Patton_Oswalt')
                                                    .and_return(@thing)
      post :create, @params
      expect(assigns(:thing)).to eq(@thing)
    end

    it "should not create a thing if not authenticated" do
      @request.env['HTTP_AUTHORIZATION'] = ''
      post :create, @params
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET show" do
    it "should show a thing" do
      get :show, { resource_name: 'Patton_Oswalt'}
      expect(response).to have_http_status(:ok)
      expect(assigns(:thing)).to eq(@thing)
    end

    it "should show not found" do
      get :show, { resource_name: 'This_Isnt_Here'}
      expect(response).to have_http_status(:not_found)
    end
  end
end
