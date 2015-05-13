require 'rails_helper'

RSpec.describe Api::V1::UsersController do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)
  before do
    @user = create(:user_alpha)
    @other_user = create(:user_bravo)
  end

  describe "GET scores" do
    it "should get all scores created by a user" do
      (1..3).each do
        @user.score_thing(build(:thing), create(:score_category))
        @other_user.score_thing(build(:thing), create(:score_category))
      end

      get :scores, {id: @user._id.to_s}, accept: :json
      expect(response).to have_http_status(:ok)

      expect(assigns(:scores)).to eq(@user.scores)

      # TODO add a view spec to ensure that scores are for this user, not another
      # controllers using jbuilder views should have consistent and accurate specs
    end
  end
end
