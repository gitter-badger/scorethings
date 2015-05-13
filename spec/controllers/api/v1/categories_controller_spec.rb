require 'rails_helper'

RSpec.describe Api::V1::CategoriesController do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)
  before do
    @user = create(:user_alpha)
    auth_token = @user.generate_auth_token.to_s
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
  end

  describe "GET all categories" do
    it "should get all categories even without authorization" do
      @request.env['HTTP_AUTHORIZATION'] = ""

      create_list(:category, 5)

      get :index, accept: :json
      expect(response).to have_http_status(:ok)
    end
  end
end
