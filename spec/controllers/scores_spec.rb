require 'rails_helper'

RSpec.describe ScoresController do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)
  before do
    @user = create(:user_alpha)
    @user.initialize_points_balance
    auth_token = @user.generate_auth_token.to_s
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
  end

  describe "POST create" do
    it "should not allow creating score if user is not authenticated" do
      @request.env['HTTP_AUTHORIZATION'] = ""
      post_data = {
          thing_input: {
              twitter_handle: 'pattonoswalt'
          }
      }

      post :create, post_data

      expect(response).to have_http_status(:unauthorized)
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

  describe "GET show" do
    it "should show the score" do
      score = create(:twitter_hashtag_score)

      get :show, {id: score._id}

      expect(response).to have_http_status(:ok)
    end

    it "should say the score can't be found if it doesn't exist" do
      get :show, {id: 'saodfks'}
      expect(response).to have_http_status(:not_found)
    end

    it "should allow the score to be viewed without request authorization" do
      @request.env['HTTP_AUTHORIZATION'] = ""

      score = create(:twitter_hashtag_score)

      get :show, {id: score._id}

      expect(response).to have_http_status(:ok)
    end
  end
end
