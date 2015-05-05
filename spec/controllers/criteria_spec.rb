require 'rails_helper'

RSpec.describe CriteriaController do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)

  describe "GET index" do
    it "should get all Criteria" do
      # create 8 criteria
      criteria = create_list(:positive_criterion, 8)
      expected_response_body = {
          criteria: criteria,
          status: :ok
      }.to_json

      get :index, accept: :json
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(expected_response_body)
    end
  end
end
