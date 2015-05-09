require 'rails_helper'

RSpec.describe Api::V1::ScoresController do
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
          score: {
              thing: {
                  type: 'TWITTER_UID',
                  value: '2121'
              }
          }
      }

      post :create, post_data

      expect(response).to have_http_status(:unauthorized)
    end

    it "should create a new score for a twitter account when given a twitter user id" do
      allow_any_instance_of(TwitterService).to receive(:get_twitter_account_from_uid).with('2121').and_return({ uid: '2121' })

      post_data = {
          score: {
              thing: {
                  type: 'TWITTER_UID',
                  value: '2121'
              }
          }
      }
      post :create, post_data
      expect(response).to have_http_status(:created)
    end

    it "should create a new score for a twitter hashtag when given a twitter hashtag" do
      post_data = {
          score: {
              thing: {
                  type: 'TWITTER_HASHTAG',
                  value: 'MayThe4thBeWithYou'
              }
          }
      }
      post :create, post_data
      expect(response).to have_http_status(:created)
    end

    it "should say the request was bad if there isn't a twitter uid or hashtag in the thing input" do
      post_data = {
          score: {
              thing: {
                  type: 'SOME_OAUTH_UID',
                  value: 'manuisfunny'
              }
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
