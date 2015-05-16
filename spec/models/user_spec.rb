require 'rails_helper'

RSpec.describe User do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)
  before do
    @user = build(:user_alpha)
  end

  describe "creating a new user with oauth" do
    it "should create a new user account with defaults" do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:twitter] = {
          provider: 'twitter',
          uid: '2121',
          info: OmniAuth::AuthHash::InfoHash.new(nickname: 'alpha')
      }
      auth = OmniAuth.config.mock_auth[:twitter]
      user = User.create_with_omniauth(auth)


      expect(user.twitter_uid).to eq('2121')
      expect(user.twitter_handle).to eq('alpha')
    end
  end

  describe "scoring things" do
    before do
      @thing = build(:twitter_account_thing)
      @score_category = create(:score_category)
      @score = Score.new(thing: @thing, score_category_id: @score_category._id)
    end

    it "should allow the user to score a thing" do
      expect(@user.scores.length).to eq(0)
      @user.create_score(@score)
      expect(@user.scores.length).to eq(1)
      expect(@user.scores.first).to eq(@score)
      expect(@score.thing).to eq(@thing)
    end

    it "should not allow adding a score category to a score that it doesn't own" do
      other_user = create(:user_bravo)
      @user.create_score(@score)
      expect {
        other_user.change_score(@score, {points: 75})
      }.to raise_error(UnauthorizedModificationError)
    end
  end
end