require 'rails_helper'

RSpec.describe Api::V1::ScoresController do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)
  before do
    @user = create(:user_alpha)
    @score_category = create(:score_category)
    auth_token = @user.generate_auth_token.to_s
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
    @general_category = create(:score_category, general: true)
    @hashtag_thing = build(:hashtag_thing)
  end

  describe "POST create" do
    it "should not allow creating score if user is not authenticated" do
      @request.env['HTTP_AUTHORIZATION'] = ""
      post_data = {
          score: {
              thing: @hashtag_thing.attributes,
              score_category_id: @score_category._id,
              points: 21
          }
      }

      post :create, post_data

      expect(response).to have_http_status(:unauthorized)
    end

    describe "creating a score with a thing type YOUTUBE_VIDEO" do
      before do
        @youtube_video_thing = build(:youtube_video_thing)
      end

      it "should create a new score for a youtube video with an external_id" do
        post_data = {
            score: {
                thing: {
                    external_id: @youtube_video_thing.external_id,
                    display_value: @youtube_video_thing.display_value,
                    type: Scorething::ThingTypes::YOUTUBE_VIDEO
                },
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

      it "should not create a new score for a youtube video without an external_id" do
        post_data = {
            score: {
                thing: {
                    external_id: nil,
                    display_value: @youtube_video_thing.display_value,
                    type: Scorething::ThingTypes::YOUTUBE_VIDEO
                },
                score_category_id: @score_category._id,
                points: 21
            }
        }
        expect(Score.all.length).to eq(0)
        post :create, post_data
        expect(response).to have_http_status(:bad_request)
        expect(Score.all.length).to eq(0)
      end
    end

    describe "creating a score with a thing type TWITTER_ACCOUNT" do
      before do
        @twitter_account_thing = build(:twitter_account_thing)
      end

      it "should create a new score for a twitter account when given just a display_value and not the external id" do
        allow_any_instance_of(TwitterService).to receive(:get_twitter_account_thing_from_params).and_return(Thing.new(@twitter_account_thing.attributes))

        post_data = {
            score: {
                thing: {
                    external_id: nil,
                    display_value: @twitter_account_thing.display_value,
                    type: Scorething::ThingTypes::TWITTER_ACCOUNT

                },
                score_category_id: @score_category._id,
                points: 21
            }
        }
        expect(Score.all.length).to eq(0)
        post :create, post_data
        expect(response).to have_http_status(:created)
        expect(Score.all.length).to eq(1)

        # FIXME this code and poorly designed specs will hide bugs in the future, need to add specs for TwitterService
        expect(Score.first.thing.external_id).to eq(@twitter_account_thing.external_id)
      end

      it "should not create a new score for a twitter account when given a twitter external_id that can't be found in twitter" do
        twitter_account_input_with_handle = {
            display_value: '',
            type: Scorething::ThingTypes::TWITTER_ACCOUNT,
            external_id: '1111111'
        }

        allow_any_instance_of(TwitterService).to receive(:get_twitter_account_thing_from_params).with(twitter_account_input_with_handle).and_return(nil)

        post_data = {
            score: {
                thing: twitter_account_input_with_handle,
                score_category_id: @score_category._id,
                points: 21
            }
        }
        expect(Score.all.length).to eq(0)
        post :create, post_data
        expect(response).to have_http_status(:bad_request)
      end

      it "should create a new score with a general category if a score_category_id is not provided" do
        allow_any_instance_of(TwitterService).to receive(:get_twitter_account_thing_from_params).and_return(Thing.new(@twitter_account_thing.attributes))

        post_data = {
            score: {
                thing: @twitter_account_thing.attributes,
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
        expect(Score.first.thing.display_value).to eq(@twitter_account_thing.display_value)
        expect(Score.first.score_category).to_not be_nil
        expect(Score.first.score_category.general).to be true
      end


    end

    it "should create a new score for a hashtag when given a hashtag" do
      post_data = {
          score: {
              thing: @hashtag_thing.attributes,
              score_category_id: @score_category._id,
              points: 21
          }
      }
      post :create, post_data
      expect(response).to have_http_status(:created)
    end

    it "should say the request was bad if there isn't a twitter uid or hashtag in the thing input" do
      bad_thing_params = {type: 'SOME_UNSUPPORTED_TYPE', display_value: 'asodf'}
      post_data = {
          score: {
              thing: bad_thing_params,
              score_category_id: @score_category._id,
              points: 21
          }
      }
      post :create, post_data
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "read/update/delete score" do
    before do
      @score = @user.score_thing(@hashtag_thing, create(:score_category))
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
        other_user_score = other_user.score_thing(build(:hashtag_thing), create(:score_category))
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
        other_user_score = other_user.score_thing(@twitter_account_thing, create(:score_category))
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
