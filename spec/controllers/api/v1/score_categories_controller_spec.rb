require 'rails_helper'

RSpec.describe Api::V1::ScoreCategoriesController do
  before do
    @user = create(:user_alpha)
    auth_token = @user.generate_auth_token.to_s
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
  end

  describe "POST create" do
    it "should create a new score category" do
      score = Score.create!(thing: build(:twitter_uid_thing), user: @user)
      category = create(:category)

      expect(score.score_categories.length).to eq(0)
      params = {
          id: score._id,
          score_category: {
              points: 21,
              category_id: category._id,
          }
      }
      post :create, params
      expect(response).to have_http_status(:created)
      score.reload
      expect(score.score_categories.length).to eq(1)
      expect(score.score_categories.first.points).to eq(21)
      expect(score.score_categories.first.category).to eq(category)
    end

    it "should not allow creating score category if user is not authenticated" do
      @request.env['HTTP_AUTHORIZATION'] = ""

      score = Score.create!(thing: build(:twitter_uid_thing), user: @user)
      category = create(:category)

      expect(score.score_categories.length).to eq(0)
      params = {
          id: score._id,
          score_category: {
              points: 21,
              category_id: category._id,
          }
      }
      post :create, params
      expect(response).to have_http_status(:unauthorized)
      score.reload
      expect(score.score_categories.length).to eq(0)
    end

    it "should not allow creating score category of score if this user is not the owner of the score" do
      other_user = create(:user_bravo)
      other_users_score = Score.create!(thing: build(:twitter_uid_thing), user: other_user)
      category = create(:category)

      expect(other_users_score.score_categories.length).to eq(0)
      params = {
          id: other_users_score._id,
          score_category: {
              points: 21,
              category_id: category._id,
          }
      }
      post :create, params
      expect(response).to have_http_status(:forbidden)
      other_users_score.reload
      expect(other_users_score.score_categories.length).to eq(0)
    end

    it "should not allow creating score category of score if score category with same category already exists" do
      # restrict uniqueness of categories in score's score categories
      # TODO can this be a model validation with mongoid?

      score = Score.create!(thing: build(:twitter_uid_thing), user: @user)
      category = create(:category)
      score.add_score_category(build(:score_category, points: 20, category: category))
      score.reload
      expect(score.score_categories.length).to eq(1)

      params = {
          id: score._id,
          score_category: {
              points: 21,
              category_id: category._id,
          }
      }

      post :create, params
      expect(response).to have_http_status(:conflict)
      score.reload
      expect(score.score_categories.length).to eq(1)
    end
  end
end
