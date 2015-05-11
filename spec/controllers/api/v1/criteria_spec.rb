require 'rails_helper'

RSpec.describe Api::V1::CriteriaController do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)

  describe "GET system_provided criteria" do
    it "should get all system Criteria" do
      user = create(:user_alpha)
      # this should not be included in system criteria
      create_list(:positive_criterion, 2, {system_provided: false, user: user})

      system_provided_criteria = []
      system_provided_criteria << Criterion.create_system_criterion(
              {name: 'Important',
              definition: 'of much or great significance or consequence'},
              levels: [
                  'Not Important',
                  'Not Very Important',
                  'Almost Important',
                  'Important',
                  'Very Important',
                  'One of the Most Important Things Ever'
              ])

      system_provided_criteria << Criterion.create_system_criterion(
          {name: 'Common',
          sign: -1,
          definition: 'of frequent occurrence; usual; familiar'},
          levels: [
              'A Little Bit Common',
              'Almost Common',
              'Common',
              'Very Common',
              'Basic'
          ])

      expected_response_body = {
          criteria: system_provided_criteria,
          status: :ok
      }.to_json

      get :system, accept: :json
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq(expected_response_body)
    end
  end
end
