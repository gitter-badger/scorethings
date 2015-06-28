require 'rails_helper'

RSpec.describe Api::V1::ScoresController do
  # TODO clean up similar specs to keep scoredThings DRY (Don't Repeat Yourself)
  before do
    @user = create(:user)
    auth_token = @user.generate_auth_token.to_s
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
    @scored_thing = create(:scored_thing)
    @criterion = create(:criterion)

    @params = {
        score: {
            scored_thing: {
                thing_id: @scored_thing.thing_id
            },
            criterion_id: @criterion._id,
            points: 2
        }
    }
  end

  describe "GET search" do

    before do
      @batman_scored_thing = create(:scored_thing, title: 'Batman')
      @seattle_scored_thing = create(:scored_thing, title: 'Seattle')

      @batman_score = create(:score, scored_thing: @batman_scored_thing, user: @user)
      @seattle_score = create(:score, scored_thing: @seattle_scored_thing, user: @user)
    end

    it "should search for scores" do
      get :search, {query: 'Batman'}
      expect(assigns(:scores)).to eq([@batman_score])

      get :search, {query: 'Seattle'}
      expect(assigns(:scores)).to eq([@seattle_score])
    end

    it "should search by username" do
      other_user = create(:user)
      other_users_batman_score = create(:score, scored_thing: @batman_scored_thing, user: other_user)
      other_users_seattle_score = create(:score, scored_thing: @seattle_scored_thing, user: other_user)

      get :search, {query: 'Batman'}
      expect(assigns(:scores)).to eq([@batman_score, other_users_batman_score])

      get :search, {query: "Batman username:#{other_user.username}"}
      expect(assigns(:scores)).to eq([other_users_batman_score])

      get :search, {query: "username:#{other_user.username}"}
      expect(assigns(:scores)).to eq([other_users_batman_score, other_users_seattle_score])

      get :search
      expect(assigns(:scores)).to eq(Score.all)

      get :search, {query: "username:this_user_does_not_exist"}
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST create" do
    it "should create a new score" do
      expect(Score.all.length).to eq(0)

      post :create, @params
      expect(assigns(:score)).to_not be_nil
      expect(response).to have_http_status(:created)
      expect(Score.all.length).to eq(1)
      expect(Score.all.first.scored_thing).to eq(@scored_thing)
      expect(Score.all.first.points).to eq(2)
      expect(Score.all.first.criterion).to eq(@criterion)
    end

    it "should not create a score if not authenticated" do
      @request.env['HTTP_AUTHORIZATION'] = ''
      post :create, @params
      expect(response).to have_http_status(:unauthorized)
    end

    it "should not create a score if a score exists for user, scored thing, and criterion" do
      existing_score = create(:score, user: @user)
      expect(Score.all.length).to eq(1)
      params_with_conflict = {
          score: {
              scored_thing: {
                  thing_id: existing_score.scored_thing.thing_id
              },
              criterion_id: existing_score.criterion._id,
              points: 2
          }
      }

      post :create, params_with_conflict
      expect(assigns(:score)).to_not be_nil
      expect(response).to have_http_status(:conflict)
      expect(assigns(:existing_score)).to eq(existing_score)
    end

    it "should not create a score for a thing that doesn't exist in wikipedia or database" do
      @params[:score][:scored_thing] = {
          thing_id: 'Q9283'
      }
      expect_any_instance_of(WikidataService).to receive(:find).with('Q9283')
                                                  .and_raise(Exceptions::ThingNotFoundError)
      expect(Score.all.length).to eq(0)
      post :create, @params
      expect(response).to have_http_status(:not_found)
      expect(Score.all.length).to eq(0)
    end

    it "should not create a score with invalid points" do
      expect(Score.all.length).to eq(0)

      @params[:score][:points] = 2000

      post :create, @params
      expect(response).to have_http_status(:bad_request)
      expect(Score.all.length).to eq(0)
    end

    it "should not create a score without points" do
      expect(Score.all.length).to eq(0)

      @params[:score][:points] = nil

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
      @params[:score][:points] = 5
      put :update, @params
      expect(assigns(:score)).to_not be_nil
      expect(assigns(:score).points).to eq(5)
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

      @params[:score][:points] = 5
      @params[:id] = other_user_score._id
      put :update, @params
      expect(@score.points).to_not eq(5)
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
end
