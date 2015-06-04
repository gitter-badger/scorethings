require 'rails_helper'

RSpec.describe Api::V1::ScoresController do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)
  before do
    @user = create(:user)
    auth_token = @user.generate_auth_token.to_s
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
    @thing = create(:thing, :twitter_account)
    @params = {
        score: {
            thing_id: @thing._id,
            points: 21,
            good_point: 50
        }
    }
  end

  describe "POST create" do
    it "should create a new score" do
      expect(Score.all.length).to eq(0)

      post :create, @params
      expect(assigns(:score)).to_not be_nil
      expect(response).to redirect_to :action => :show, id: assigns(:score)._id.to_s
      expect(Score.all.length).to eq(1)
      expect(Score.all.first.thing).to eq(@thing)
      expect(Score.all.first.points).to eq(21)
    end

    it "should not create a score if not authenticated" do
      @request.env['HTTP_AUTHORIZATION'] = ''
      post :create, @params
      expect(response).to have_http_status(:unauthorized)
    end

    it "should not create a score for a thing that doesn't exist" do
      expect(Score.all.length).to eq(0)
      @params[:score][:thing_id] = '123notathing'

      post :create, @params
      expect(response).to have_http_status(:not_found)
      expect(Score.all.length).to eq(0)
    end

    it "should not create a score with invalid points" do
      expect(Score.all.length).to eq(0)

      @params[:score][:points] = 1000

      post :create, @params
      expect(response).to have_http_status(:bad_request)
      expect(Score.all.length).to eq(0)
    end

    it "should not create a score without a good point" do
      expect(Score.all.length).to eq(0)

      @params[:score][:good_point] = nil

      post :create, @params
      expect(response).to have_http_status(:bad_request)
      expect(Score.all.length).to eq(0)
    end
  end

  describe "PUT update" do
    before do
      @score = Score.new(@params[:score])
      @user.create_score(@score)
      @params[:id] = @score._id
    end

    it "should update a score" do
      @params[:score][:points] = 55
      put :update, @params
      expect(assigns(:score)).to_not be_nil
      expect(assigns(:score).points).to eq(55)
    end

    it "should not update a score points if invalid" do
      @params[:score][:points] = 1000
      put :update, @params
      expect(@score.points).to_not eq(1000)
      expect(response).to have_http_status(:bad_request)
    end

    it "should not update a score points if not owner" do
      other_user = create(:user)
      other_user_score = build(:score)
      other_user.create_score(other_user_score)

      @params[:score][:points] = 55
      @params[:id] = other_user_score._id
      put :update, @params
      expect(@score.points).to_not eq(55)
      expect(response).to have_http_status(:forbidden)
    end

    it "should not update a score if not authenticated" do
      @request.env['HTTP_AUTHORIZATION'] = ''
      put :update, @params
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "DELETE destroy" do
    before do
      @score = Score.new(@params[:score])
      @user.create_score(@score)
      @delete_params = {id: @score._id}
    end

    it "should delete a score" do
      expect(Score.all.length).to eq(1)
      delete :destroy, @delete_params
      expect(Score.all.length).to eq(0)
    end

    it "should not delete a score points if not owner" do
      other_user = create(:user)
      other_user_score = build(:score)
      other_user.create_score(other_user_score)

      expect(Score.all.length).to eq(2)
      delete :destroy, {id: other_user_score._id}
      expect(Score.all.length).to eq(2)
      expect(response).to have_http_status(:forbidden)
    end

    it "should not delete a score if not authenticated" do
      @request.env['HTTP_AUTHORIZATION'] = ''
      delete :destroy, @delete_params
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "violating uniqueness of a score's user and thing" do
    before do
      @existing_score = build(:score, thing: @thing)
      @user.create_score(@existing_score)
    end

    it "should not allow another score to be created that is not unique" do
      post :create, @params
      expect(response).to have_http_status(:conflict)
    end
  end
end
