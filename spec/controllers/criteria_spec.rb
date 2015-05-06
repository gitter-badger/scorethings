require 'rails_helper'

RSpec.describe CriteriaController do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)

  describe "GET system_provided criteria" do
    it "should get all Criteria" do
      user = create(:user_alpha)
      user_criteria = create_list(:positive_criterion, 2, {system_provided: false, user: user})
      system_provided_criteria = create_list(:positive_criterion, 3, {system_provided: true})

      all_criteria = user_criteria + system_provided_criteria

      expected_response_body = {
          criteria: all_criteria,
          status: :ok
      }.to_json

      get :index, accept: :json
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(expected_response_body)
    end

    it "should get all Criteria that has system_provided field true" do
      user = create(:user_alpha)
      create(:positive_criterion, {system_provided: false, user: user})
      system_provided_criterion = create(:positive_criterion, {system_provided: true})

      expected_response_body = {
          criteria: [system_provided_criterion],
          status: :ok
      }.to_json

      get :index, {system_provided: true}, accept: :json
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(expected_response_body)
    end

    it "should get all Criteria created by a user" do
      user = create(:user_alpha)
      other_user = create(:user_bravo)
      create(:positive_criterion, {system_provided: false, user: user})
      criteria_of_other_user = create(:positive_criterion, {system_provided: false, user: other_user})
      create(:positive_criterion, {system_provided: true})

      expected_response_body = {
          criteria: [criteria_of_other_user],
          status: :ok
      }.to_json

      get :index, {user_id: other_user._id}, accept: :json
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(expected_response_body)
    end
  end
end
