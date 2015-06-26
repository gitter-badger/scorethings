require 'rails_helper'

RSpec.describe Api::V1::StatsController do
  before do
    @user = create(:user)
    auth_token = @user.generate_auth_token.to_s
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
    @thing = create(:thing)
    @criterion = create(:criterion)
  end

  describe "GET stats" do
    it "should get stats for a thing with no scores" do
      get :index, { id: @thing._id }
      expect(response).to have_http_status(:ok)
      expect(assigns(:stats).total).to eq(0)
    end

    it "should get stats for a thing" do
      create(:score, thing: @thing, points: 4, criterion: @criterion, user: @user)
      create(:score, thing: @thing, points: 8, criterion: @criterion, user: @user)

      get :index, { thing_id: @thing._id }
      expect(response).to have_http_status(:ok)
      expect(assigns(:stats).total).to eq(2)
      expect(assigns(:stats).avg).to eq(6)
      expect(assigns(:stats).min).to eq(4)
      expect(assigns(:stats).max).to eq(8)
    end

    it "should get stats for a thing and criterion" do
      other_criterion = create(:criterion)
      create(:score, thing: @thing, points: 4, criterion: @criterion, user: @user)
      create(:score, thing: @thing, points: 5, criterion: other_criterion, user: @user)

      get :index, { thing_id: @thing._id, criterion_id: @criterion._id }
      expect(response).to have_http_status(:ok)
      expect(assigns(:stats).total).to eq(1)
      expect(assigns(:stats).avg).to eq(4)
      expect(assigns(:stats).min).to eq(4)
      expect(assigns(:stats).max).to eq(4)
    end

    it "should get stats for a thing and user" do
      other_criterion = create(:criterion)
      other_user = create(:user)
      other_thing = create(:thing)

      create(:score, thing: @thing, points: 4, criterion: @criterion, user: other_user)
      create(:score, thing: @thing, points: 8, criterion: other_criterion, user: other_user)
      create(:score, thing: other_thing, points: 4, criterion: other_criterion, user: other_user)
      create(:score, thing: @thing, points: 5, criterion: other_criterion, user: @user)

      get :index, { thing_id: @thing._id, user_id: other_user._id }
      expect(response).to have_http_status(:ok)
      expect(assigns(:stats).total).to eq(2)
      expect(assigns(:stats).avg).to eq(6)
      expect(assigns(:stats).min).to eq(4)
      expect(assigns(:stats).max).to eq(8)
    end
  end
end
