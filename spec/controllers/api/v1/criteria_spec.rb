require 'rails_helper'

RSpec.describe Api::V1::CriteriaController do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)
  before do
    @user = create(:user_alpha)
    auth_token = @user.generate_auth_token.to_s
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
  end

  describe "GET system_provided criteria" do
    it "should get all system Criteria without authentication" do
      @request.env['HTTP_AUTHORIZATION'] = ""
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

      get :system, accept: :json
      expect(response).to have_http_status(:ok)
    end
  end
  describe "POST criterion" do
    it "should create a new criterion for the user" do
      post_data = {
          criterion: {
              name: 'Tasty',
              definition: 'tastes good, yummy, good to eat and stuff',
              sign: 1
          }
      }

      post :create, post_data

      expect(response).to have_http_status(:created)
    end
    it "should not allow posting criterion if not authenticated" do
      @request.env['HTTP_AUTHORIZATION'] = ""
      post_data = {
          criterion: {
              name: 'Tasty',
              definition: 'tastes good, yummy, good to eat and stuff',
              sign: 1
          }
      }

      post :create, post_data

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
