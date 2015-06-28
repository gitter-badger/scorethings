require 'rails_helper'

RSpec.describe Api::V1::ThingsController do
  before do
    @user = create(:user)
    auth_token = @user.generate_auth_token.to_s
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
  end

  describe "GET find" do
    it "should find" do
      thing = { id: 'Q1234'}

      expect_any_instance_of(ThingService).to receive(:find).with('Q1234')
                                                  .and_return(thing)

      get :find, { thing_id: 'Q1234'}

      expect(response).to have_http_status(:ok)
      expect(assigns(:thing)).to eq(thing)
    end

    it "should search not found" do
      expect_any_instance_of(ThingService).to receive(:find).with('Q1234')
                                                  .and_raise(Exceptions::ThingNotFoundError)

      get :find, { thing_id: 'Q1234'}

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET search" do
    it "should search" do
      search_results = [{ id: 'Q1234'}, {id: 'Q5678'}]

      expect_any_instance_of(ThingService).to receive(:search).with('Patton Oswalt')
                                                  .and_return(search_results)

      get :search, { query: 'Patton Oswalt'}

      expect(response).to have_http_status(:ok)
      expect(assigns(:search_results)).to eq(search_results)
    end
  end
end
