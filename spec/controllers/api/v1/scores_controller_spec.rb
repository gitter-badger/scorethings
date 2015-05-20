require 'rails_helper'

RSpec.describe Api::V1::ScoresController do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)
  before do
    @user = create(:user_alpha)
    @score_category = create(:score_category)
    auth_token = @user.generate_auth_token.to_s
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
    @general_category = create(:score_category, general: true)
  end

  describe "POST create" do
    it "should not allow creating score if user is not authenticated" do
      thing = create(:thing, :twitter_account)

      @request.env['HTTP_AUTHORIZATION'] = ""
      post_data = {
          score: {
              score_category_id: @score_category._id,
              points: 21,
              thing_id: thing._id
          },
      }

      post :create, post_data

      expect(response).to have_http_status(:unauthorized)
    end

    describe "creating a score with a things type YOUTUBE_VIDEO" do
      before do
        @youtube_video_thing = create(:thing, :youtube_video)
      end

      it "should create a new score for a youtube video" do
        post_data = {
            score: {
                thing_id: @youtube_video_thing._id,
                score_category_id: @score_category._id,
                points: 21
            }
        }
        expect(Score.all.length).to eq(0)
        post :create, post_data
        expect(response).to have_http_status(:created)
        expect(Score.all.length).to eq(1)

        # FIXME this code and poorly designed specs will hide bugs in the future, need to add specs for TwitterService
        expect(Score.first.thing.external_id).to eq(@youtube_video_thing.external_id)
      end
    end

    describe "creating a score with a things type TWITTER_ACCOUNT" do
      before do
        @twitter_account_thing = create(:thing, :twitter_account)
      end

      it "should not create a new score for a twitter account thing when it cannot be retrieved with the thing id" do
        post_data = {
            score: {
                thing_id: 'notanidindb',
                score_category_id: @score_category._id,
                points: 21
            }
        }
        expect(Score.all.length).to eq(0)
        post :create, post_data
        expect(Score.all.length).to eq(0)
        expect(response).to have_http_status(:not_found)
      end

      it "should not create a new score without a thing id" do
        post_data = {
            score: {
                thing_id: nil,
                score_category_id: @score_category._id,
                points: 21
            }
        }
        expect(Score.all.length).to eq(0)
        post :create, post_data
        expect(response).to have_http_status(:not_found)
      end

      it "should create a new score with a general category if a score_category_id is not provided" do
        allow_any_instance_of(ThingService).to receive(:load).with(@twitter_account_thing.type, @twitter_account_thing.external_id).and_return(@twitter_account_thing)

        post_data = {
            score: {
                thing_id: @twitter_account_thing._id,
                score_category_id: nil,
                points: 21
            }
        }
        expect(Score.all.length).to eq(0)
        post :create, post_data
        expect(response).to have_http_status(:created)
        expect(Score.all.length).to eq(1)

        # TODO one of the problems with using factory in spec is that
        # comparing result with expectation hides actual values
        # maybe shouldn't use factory for this one, could hide bugs (what is factory's external_id)
        expect(Score.first.thing.type).to eq(@twitter_account_thing.type)
        expect(Score.first.thing.external_id).to eq(@twitter_account_thing.external_id)
        expect(Score.first.thing.title).to eq(@twitter_account_thing.title)
        expect(Score.first.score_category).to_not be_nil
        expect(Score.first.score_category.general).to be true
      end
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
