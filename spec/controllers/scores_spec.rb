require 'rails_helper'

RSpec.describe ScoresController do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)

  # TODO complete spec, it is currently failing
  xdescribe "POST create" do
    it "should create a new score for a twitter account when given a twitter handle" do
      twitter_account = {
          twitter_uid: '2121'
      }
      allow_any_instance_of(TwitterService).to receive(:get_twitter_account_from_handle).with('pattonoswalt').and_return(twitter_account)
      user = create(:user_alpha)
      auth_token = user.generate_auth_token.to_s

      post_data = {
          thing_input: {
              twitter_handle: 'pattonoswalt'
          }
      }

      @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"

      # copied from http://stackoverflow.com/a/14782580/4694250
      post :create, post_data.to_json, { CONTENT_TYPE: 'application/json', ACCEPT: 'application/json' }

      expect(response).to have_http_status(:created)
      expect(response)
    end
  end
end
