require 'rails_helper'

RSpec.describe Api::V1::ThingsController do
  before do
    @user = create(:user)
    auth_token = @user.generate_auth_token.to_s
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
    @thing = create(:thing, title: 'Patton Oswalt')
  end

  describe "GET show" do
    it "should show a thing" do
      get :show, { id: @thing._id }
      expect(response).to have_http_status(:ok)
      expect(assigns(:thing)).to eq(@thing)
    end

    it "should show not found" do
      get :show, { id: '293823' }
      expect(response).to have_http_status(:not_found)
    end
  end
end
