require 'rails_helper'

RSpec.describe Api::V1::ThingStatsController do
  before do
    @user = create(:user)
    auth_token = @user.generate_auth_token.to_s
    @request.env['HTTP_AUTHORIZATION'] = "Bearer #{auth_token}"
    @thing = create(:thing, title: 'Patton Oswalt')
    @criterion = create(:criterion)
  end

  describe "GET stats" do
    it "should get stats for a thing with no scores" do
      get :show, { id: @thing._id }
      expect(response).to have_http_status(:ok)
      expect(assigns(:thing_stats).total).to eq(0)
    end

    it "should get stats for a thing with scores" do
      create(:score, thing: @thing, points: 4, criterion: @criterion, user: @user)
      create(:score, thing: @thing, points: 8, criterion: @criterion, user: @user)

      get :show, { id: @thing._id }
      expect(response).to have_http_status(:ok)
      expect(assigns(:thing_stats).total).to eq(2)
      expect(assigns(:thing_stats).avg).to eq(6)
      expect(assigns(:thing_stats).min).to eq(4)
      expect(assigns(:thing_stats).max).to eq(8)
    end

    it "should get stats for a thing and criterion with scores" do
      other_criterion = create(:criterion)
      create(:score, thing: @thing, points: 4, criterion: @criterion, user: @user)
      create(:score, thing: @thing, points: 5, criterion: other_criterion, user: @user)

      get :show, { id: @thing._id, criterion_id: @criterion._id }
      expect(response).to have_http_status(:ok)
      expect(assigns(:thing_stats).total).to eq(1)
      expect(assigns(:thing_stats).avg).to eq(4)
      expect(assigns(:thing_stats).min).to eq(4)
      expect(assigns(:thing_stats).max).to eq(4)
    end
  end
end
