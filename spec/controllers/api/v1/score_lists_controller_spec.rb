require 'rails_helper'

RSpec.describe Api::V1::ScoreListsController do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)
  before do
    @user = create(:user_alpha)
    auth_token = @user.generate_auth_token.to_s
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
  end

  describe "POST create" do
    it "should not allow creating score_list if user is not authenticated" do
      @request.env['HTTP_AUTHORIZATION'] = ""
      post_data = { score_list: { name: 'Another score list'} }
      post :create, post_data
      expect(response).to have_http_status(:unauthorized)
    end

    it "should allow creating score_list if user is authenticated" do
      post_data = { score_list: { name: 'Another score list'} }
      post :create, post_data
      expect(response).to have_http_status(:created)
    end
  end

  describe "read/update/delete score list" do
    before do
      @score_list = @user.create_score_list(name: 'Cool Movie Theaters')
      build_list(:score, 3).each do |score|
        @user.create_score(score)
      end
      @other_user = create(:user_bravo)
      @other_user_score_list = @other_user.create_score_list(name: "This Other User's List")
    end

    describe "PUT score list" do
      it "should change the name of a score list" do
        put :update, {id: @score_list._id, score_list: {name: 'Some Stuff About Cats'}}
        expect(response).to have_http_status(:ok)

        @score_list.reload
        expect(@score_list.name).to eq('Some Stuff About Cats')
      end

      it "should not allow other users to change the score list of a user" do
        put :update, {id: @other_user_score_list._id, score_list: {name: 'Cats Suck'}}
        expect(response).to have_http_status(:forbidden)

        @score_list.reload
        expect(@other_user_score_list.name).to eq("This Other User's List")
      end
    end

    describe "DELETE score list" do
      it "should delete the score list" do
        expect(ScoreList.where(id: @score_list._id).first.nil?).to be false
        delete :destroy, {id: @score_list._id}
        expect(response).to have_http_status(:ok)

        expect(ScoreList.where(id: @score_list._id).first.nil?).to be true
      end

      it "should not allow other users to delete the score list of a user" do
        expect(ScoreList.where(id: @other_user_score_list._id).first.nil?).to be false
        delete :destroy, {id: @other_user_score_list._id}
        expect(response).to have_http_status(:forbidden)

        expect(ScoreList.where(id: @other_user_score_list._id).first.nil?).to be false
      end
    end

    describe "GET score list" do
      it "should say the score list can't be found if it doesn't exist" do
        get :show, {id: 'saodfks'}
        expect(response).to have_http_status(:not_found)
      end

      it "should allow the score to be viewed without request authorization" do
        @request.env['HTTP_AUTHORIZATION'] = ""
        get :show, {id: @score_list._id}
        expect(response).to have_http_status(:ok)
      end
    end

    describe "add/remove score" do
      before do
        @score = @user.create_score(build(:score))
      end

      it "should add a score" do
        expect(@score_list.scores.length).to eq(0)
        post :add_score, {score_list_id: @score_list.id.to_s, id: @score.id.to_s}
        @score_list.reload
        expect(@score_list.scores.length).to eq(1)
        expect(response).to have_http_status(:ok)
      end


      it "should remove a score" do
        @user.add_score_to_score_list(@score_list, @score)
        expect(@score_list.scores.length).to eq(1)
        delete :remove_score, {score_list_id: @score_list.id.to_s, id: @score.id.to_s}
        @score_list.reload
        expect(@score_list.scores.length).to eq(0)
        expect(response).to have_http_status(:ok)
      end

      describe "restricting access to score list" do
        before do
          @other_user = create(:user_bravo)
          @other_user_score = @other_user.create_score(build(:score))
          @other_user_score_list = @other_user.create_score_list(name: 'Another user score list')
        end

        it "should not add to another user's score list" do
          expect(@other_user_score_list.scores.length).to eq(0)
          post :add_score, {score_list_id: @other_user_score_list.id.to_s, id: @score.id.to_s}
          expect(response).to have_http_status(:forbidden)
          @score_list.reload
          expect(@other_user_score_list.scores.length).to eq(0)
        end

        it "should not add another user's score to score list" do
          expect(@score_list.scores.length).to eq(0)
          post :add_score, {score_list_id: @score_list.id.to_s, id: @other_user_score.id.to_s}
          expect(response).to have_http_status(:forbidden)
          @score_list.reload
          expect(@score_list.scores.length).to eq(0)
        end

        it "should not add another user's score to another user's score list" do
          expect(@other_user_score_list.scores.length).to eq(0)
          post :add_score, {score_list_id: @other_user_score_list.id.to_s, id: @other_user_score.id.to_s}
          expect(response).to have_http_status(:forbidden)
          @score_list.reload
          expect(@other_user_score_list.scores.length).to eq(0)
        end
      end
    end
  end
end
