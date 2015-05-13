require 'rails_helper'

RSpec.describe Api::V1::ScoresController do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)
  before do
    @user = create(:user_alpha)
    @category = create(:category)
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
                  value: 2121
              },
              category_id: @category._id,
              points: 21
          }
      }

      post :create, post_data

      expect(response).to have_http_status(:unauthorized)
    end

    it "should create a new score for a twitter account when given a twitter user id" do
      allow_any_instance_of(TwitterService).to receive(:get_twitter_account_from_uid).with('2121').and_return({ id: '2121' })

      post_data = {
          score: {
              thing: {
                  type: 'TWITTER_UID',
                  value: 2121
              },
              category_id: @category._id,
              points: 21
          }
      }
      expect(Score.all.length).to eq(0)
      post :create, post_data
      expect(response).to have_http_status(:created)
      expect(Score.all.length).to eq(1)
      expect(Score.first.thing.type).to eq('TWITTER_UID')
      expect(Score.first.thing.value).to eq('2121')
    end

    it "should create a new score for a twitter hashtag when given a twitter hashtag" do
      post_data = {
          score: {
              thing: {
                  type: 'TWITTER_HASHTAG',
                  value: 'MayThe4thBeWithYou'
              },
              category_id: @category._id,
              points: 21
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
              },
              category_id: @category._id,
              points: 21
          }
      }
      post :create, post_data
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "read/update/delete score" do
    before do
      @score = @user.score_thing(build(:twitter_hashtag_thing), create(:category))
    end

    describe "PUT score" do
      it "should change the points of a score" do
        put :update, {id: @score._id, score: {points: 94}}
        expect(response).to have_http_status(:ok)

        @score.reload
        expect(@score.points).to eq(94)
      end

      # TODO write spec for not allowing update if not owner user
    end

    describe "DELETE score" do
      it "should delete the score" do
        expect(Score.where(id: @score._id).first.nil?).to be false
        delete :delete, {id: @score._id}
        expect(response).to have_http_status(:ok)

        expect(Score.where(id: @score._id).first.nil?).to be true
      end

      # TODO write spec for not allowing delete if not owner user
    end

    describe "GET score" do
      it "should say the score can't be found if it doesn't exist" do
        get :show, {id: 'saodfks'}
        expect(response).to have_http_status(:not_found)
      end

      it "should allow the score to be viewed without request authorization" do
        @request.env['HTTP_AUTHORIZATION'] = ""
        get :show, {id: @score._id}
        expect(response).to have_http_status(:ok)
      end
    end
  end


end
