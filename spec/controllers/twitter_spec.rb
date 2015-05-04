require 'rails_helper'

RSpec.describe TwitterController do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)

  describe "GET lists" do
    it "should get this twitter lists from the twitter service" do
      allow_any_instance_of(TwitterService).to receive(:get_lists).and_return([])
      user = create(:user_alpha)
      auth_token = user.generate_auth_token.to_s

      @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
      get :lists

      expect(response.status).to eq(200)
    end
  end
end
