require 'rails_helper'

RSpec.describe Api::V1::DbpediaThingsController do
  before do
    @user = create(:user)
    auth_token = @user.generate_auth_token.to_s
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
  end

  describe "GET show" do
    before do
      @params = {
          dbpedia_thing: {
              resource_name: 'Patton_Oswalt'
          }
      }
      @dbpedia_thing = {
          resource_name: 'Patton_Oswalt',
          label: 'Patton Oswalt'
      }
    end

    it "should show a dbpedia thing" do
      expect_any_instance_of(ThingService).to receive(:find_from_dbpedia).with('Patton_Oswalt')
                                                  .and_return(@dbpedia_thing)

      get :show, { resource_name: 'Patton_Oswalt' }
      expect(response).to have_http_status(:ok)
      expect(assigns(:dbpedia_thing)).to eq(@dbpedia_thing)
    end

    it "should show not found" do
      get :show, { resource_name: 'This_Isnt_Here'}
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET search" do
    it "should search" do
      search_results = [
        {
          resource_name: 'Patton_Oswalt',
          label: 'Patton Oswalt'
        },
        {
            resource_name: 'Matt_Oswalt',
            label: 'Matt Oswalt'
        }
      ]

      expect_any_instance_of(ThingService).to receive(:search).with('Oswalt')
                                                  .and_return(search_results)

      get :search, { query: 'Oswalt'}

      expect(response).to have_http_status(:ok)
      expect(assigns(:search_results)).to eq(search_results)
    end
  end
end
