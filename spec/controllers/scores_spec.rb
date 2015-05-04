require 'rails_helper'

RSpec.describe ScoresController do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)

  describe "POST create" do
    it "should not allow creating score if user is not authenticated" do
      post_data = {
          thing_input: {
              twitter_handle: 'pattonoswalt'
          }
      }

      post :create, post_data

      expect(response).to have_http_status(:unauthorized)
    end

    describe "creating a score" do
      before do
        @user = create(:user_alpha)
        auth_token = @user.generate_auth_token.to_s
        @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
      end

      it "should create a new score for a twitter account when given a twitter handle" do
        twitter_account = { uid: '2121' }
        allow_any_instance_of(TwitterService).to receive(:get_twitter_account_from_handle).with('pattonoswalt').and_return(twitter_account)

        post_data = {
            thing_input: {
                twitter_handle: 'pattonoswalt'
            }
        }
        post :create, post_data
        expect(response).to have_http_status(:created)
      end

      it "should create a new score for a twitter hashtag when given a twitter handle" do
        post_data = {
            thing_input: {
                twitter_hashtag: 'MayThe4thBeWithYou'
            }
        }
        post :create, post_data
        expect(response).to have_http_status(:created)
      end

      it "should say the request was bad if there isn't a twitter uid or hashtag in the thing input" do
        post_data = {
            thing_input: {
                github_handle: 'manuisfunny'
            }
        }
        post :create, post_data
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
