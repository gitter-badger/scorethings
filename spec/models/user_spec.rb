require 'rails_helper'

RSpec.describe User do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)
  before do
    @user = create(:user_alpha)
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

  describe "organizing scores into score lists" do
    before do
      @score = @user.create_score(build(:score))
    end

    it "should allow the user to create an empty score list" do
      expect(@user.score_lists.length).to eq(1)
      score_list = @user.create_score_list(name: 'Another Empty Score List')
      expect(@user.score_lists.length).to eq(2)
      expect(@user.score_lists.second).to eq(score_list)
      expect(@user.score_lists.second.scores.length).to eq(0)
    end

    it "should allow the user to add a score to the score list" do
      score_list = @user.create_score_list(name: 'Another Empty Score List')

      expect(@user.score_lists.first.scores.length).to eq(1)
      @user.add_score_to_score_list(score_list, @score)
      expect(@user.score_lists.first.scores.length).to eq(1)
    end

    it "should not allow a user to add a score to another user's score list" do
      other_user = create(:user_bravo)
      other_user_score_list = other_user.create_score_list(name: 'First Score List')

      other_user_score = other_user.create_score(build(:score))

      # cannot add other user's score to other user's score list
      expect {
        @user.add_score_to_score_list(other_user_score_list, other_user_score)
      }.to raise_error(UnauthorizedModificationError)

      # cannot user's score to other user's score list
      expect {
        @user.add_score_to_score_list(other_user_score_list, @score)
      }.to raise_error(UnauthorizedModificationError)
    end

    describe "removing a score from a score list" do
      before do
        @score_list = @user.create_score_list(name: 'My Scores For Patton Oswalt')
        @another_score = @user.create_score(build(:score))

        @user.add_score_to_score_list(@score_list, @score)
        @user.add_score_to_score_list(@score_list, @another_score)
      end

      it "should remove a score from a score list" do
        @user.remove_score_from_score_list(@score_list, @another_score)
        expect(@user.scores.length).to eq(2)
        expect(@user.score_lists.first.scores.length).to eq(1)
        expect(@user.score_lists.first.scores.first).to eq(@score)
      end

      it "should not remove a score from another user's score list" do
        other_user = create(:user_bravo)
        other_user_score_list = other_user.create_score_list(name: 'First Score List')
        other_user_score = other_user.create_score(build(:score))
        other_user.add_score_to_score_list(other_user_score_list, other_user_score)
        expect(other_user_score_list.scores.length).to eq(1)

        expect {
          @user.remove_score_from_score_list(other_user_score_list, other_user_score)
        }.to raise_error(UnauthorizedModificationError)
        expect(other_user_score_list.scores.length).to eq(1)
      end
    end
  end
end