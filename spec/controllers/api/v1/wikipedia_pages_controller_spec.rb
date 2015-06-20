require 'rails_helper'

RSpec.describe Api::V1::WikipediaPagesController do
  before do
    @user = create(:user)
    auth_token = @user.generate_auth_token.to_s
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
  end

  describe "GET search" do
    it "should search" do
      wikipedia_page_info = { title: 'Patton Oswalt', page_id: 1234}

      expect_any_instance_of(ThingService).to receive(:find).with('Patton Oswalt')
                                                  .and_return(wikipedia_page_info)

      get :search, { query: 'Patton Oswalt'}

      expect(response).to have_http_status(:ok)
      expect(assigns(:wikipedia_page_info)).to eq(wikipedia_page_info)
    end

    it "should search not found" do
      expect_any_instance_of(ThingService).to receive(:find).with('Patton Oswalt')
                                                  .and_raise(Exceptions::WikipediaPageInfoNotFoundError)

      get :search, { query: 'Patton Oswalt'}

      expect(response).to have_http_status(:not_found)
    end
  end
end
