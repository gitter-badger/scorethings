require 'rails_helper'

RSpec.describe Api::V1::ScoresController do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)
  before do
    @user = create(:user_alpha)
    @score_category = create(:score_category)
    auth_token = @user.generate_auth_token.to_s
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
    @general_category = create(:score_category, general: true)
    @twitter_account_thing = create(:thing, :twitter_account)
  end

  describe "POST score_thing" do
    it "should not allow creating score if user is not authenticated" do
      thing = create(:thing, :twitter_account)

      @request.env['HTTP_AUTHORIZATION'] = ""
      post_data = {
          thing_type: thing.type,
          external_id: thing.external_id,
          score: {
              score_category_id: @score_category._id,
              points: 21
          },
      }
      post :score_thing, post_data
      expect(response).to have_http_status(:unauthorized)
    end

    describe "creating a score with a things type YOUTUBE_VIDEO" do
      before do
        @youtube_video_thing = create(:thing, :youtube_video)
      end

      it "should create a new score for a youtube video" do
        post_data = {
            thing_type: @youtube_video_thing.type,
            external_id: @youtube_video_thing.external_id,
            score: {
                score_category_id: @score_category._id,
                points: 21
            }
        }
        expect(Score.all.length).to eq(0)
        post :score_thing, post_data
        expect(response).to have_http_status(:created)
        expect(Score.all.length).to eq(1)

        expect(Score.first.thing).to eq(@youtube_video_thing)
      end
    end

    describe "creating a score with a things type HASHTAG" do
      before do
        @hashtag_thing = create(:thing, :hashtag)
      end

      it "should create a new score for a hashtag thing" do
        post_data = {
            thing_type: @hashtag_thing.type,
            external_id: @hashtag_thing.external_id,
            score: {
                score_category_id: @score_category._id,
                points: 21
            }
        }
        expect(Score.all.length).to eq(0)
        post :score_thing, post_data
        expect(response).to have_http_status(:created)
        expect(Score.all.length).to eq(1)

        expect(Score.first.thing).to eq(@hashtag_thing)
      end
    end

    describe "creating a score with a things type TWITTER_ACCOUNT" do
      it "should create a new score for a twitter account thing" do
        post_data = {
            thing_type: @twitter_account_thing.type,
            external_id: @twitter_account_thing.external_id,
            score: {
                score_category_id: @score_category._id,
                points: 21
            }
        }
        expect(Score.all.length).to eq(0)
        post :score_thing, post_data
        expect(response).to have_http_status(:created)
        expect(Score.all.length).to eq(1)

        expect(Score.first.thing).to eq(@twitter_account_thing)
      end
    end

    describe "creating a score with a score category" do
      before do
        @another_non_general_score_category = create(:score_category, general: false)
      end

      it "should create a new score with the score category passed in params" do
        post_data = {
            thing_type: @twitter_account_thing.type,
            external_id: @twitter_account_thing.external_id,
            score: {
                score_category_id: @another_non_general_score_category._id.to_s,
                points: 21
            }
        }
        post :score_thing, post_data

        expect(Score.first.score_category).to eq(@another_non_general_score_category)
      end

      it "should create a new score with the general score category when no score category passed in params" do
        post_data = {
            thing_type: @twitter_account_thing.type,
            external_id: @twitter_account_thing.external_id,
            score: {
                score_category_id: nil,
                points: 21
            }
        }
        post :score_thing, post_data

        expect(Score.first.score_category).to eq(@general_category)
      end
    end

    it "should create a new score with a general category if a score_category_id is not provided" do
      post_data = {
          thing_type: @twitter_account_thing.type,
          external_id: @twitter_account_thing.external_id,
          score: {
              score_category_id: nil,
              points: 21
          }
      }
      expect(Score.all.length).to eq(0)
      post :score_thing, post_data
      expect(response).to have_http_status(:created)
      expect(Score.all.length).to eq(1)

      expect(Score.first.thing).to eq(@twitter_account_thing)
      expect(Score.first.score_category.general?).to be true
    end
  end

  describe "read/update/delete score" do
    before do
      @thing = create(:thing, :twitter_account)
      @score = @user.create_score(Score.new(thing: @thing, score_category: @score_category))
    end

    describe "PUT score" do
      it "should change the points of a score" do
        put :update, {id: @score._id, score: {points: 94}}
        expect(response).to have_http_status(:ok)

        @score.reload
        expect(@score.points).to eq(94)
      end

      it "should not allow other users to change the score" do
        other_user = create(:user_bravo)
        other_user_score = other_user.create_score(Score.new(thing: @thing, score_category: @score_category))
        put :update, {id: other_user_score._id, score: {points: 55}}
        expect(response).to have_http_status(:forbidden)
      end
    end

    describe "DELETE score" do
      it "should delete the score" do
        expect(Score.where(id: @score._id).first.nil?).to be false
        delete :destroy, {id: @score._id}
        expect(response).to have_http_status(:ok)

        expect(Score.where(id: @score._id).first.nil?).to be true
      end

      it "should not allow other users to delete the score" do
        other_user = create(:user_bravo)
        other_user_score = other_user.create_score(Score.new(thing: @thing, score_category: @score_category))
        expect(Score.where(id: other_user_score._id).first.nil?).to be false
        delete :destroy, {id: other_user_score._id}
        expect(response).to have_http_status(:forbidden)

        expect(Score.where(id: other_user_score._id).first.nil?).to be false
      end
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
