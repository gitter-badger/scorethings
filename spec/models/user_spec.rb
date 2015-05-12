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
      @thing = build(:twitter_hashtag_thing)
    end

    it "should score a thing" do
      expect(@user.scores.length).to eq(0)
      score = @user.score_thing(@thing)
      expect(@user.scores.length).to eq(1)
      expect(@user.scores.first).to eq(score)
      expect(score.thing).to eq(@thing)
    end

    it "should add a score category" do
      score = @user.score_thing(@thing)
      category = create(:category)
      expect(score.score_categories.length).to eq(0)
      score_category = @user.add_score_category(score, category, 75)

      expect(score_category.category).to eq(category)
      expect(score.score_categories.length).to eq(1)
      expect(score.score_categories.first).to eq(score_category)
    end

    it "should not allow adding a score category to a score that it doesn't own" do
      score = @user.score_thing(@thing)
      category = create(:category)
      expect(score.score_categories.length).to eq(0)

      other_user = create(:user_bravo)
      expect {
        other_user.add_score_category(score, category, 75)
      }.to raise_error(UnauthorizedModificationError)
    end

  end
end