require 'rails_helper'

RSpec.describe User do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)

  def mock_auth(provider, uid, info_attrs)
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[provider.to_s] = {
        provider: provider,
        uid: uid,
        info: OmniAuth::AuthHash::InfoHash.new(info_attrs)
    }
    OmniAuth.config.mock_auth[provider.to_s]
  end

  describe "creating a new user with oauth" do
    it "should create a new user account with a twitter auth" do
      auth = mock_auth('twitter', '2121', {nickname: 'alpha'})

      expect(User.all.length).to eq(0)
      user = User.create_with_omniauth(auth)

      expect(User.all.length).to eq(1)
      expect(user.auth_provider.type).to eq('twitter')
      expect(user.auth_provider.uid).to eq('2121')
      expect(user.auth_provider.handle).to eq('alpha')
    end

    it "should create a new user account with a google auth" do
      auth = mock_auth('google', '2121', {name: 'John Doe'})

      expect(User.all.length).to eq(0)
      user = User.create_with_omniauth(auth)

      expect(User.all.length).to eq(1)
      expect(user.auth_provider.type).to eq('google')
      expect(user.auth_provider.uid).to eq('2121')
      expect(user.auth_provider.handle).to eq('John Doe')
      expect(user.username).to_not be_nil
    end

    it "should not create a new user account without a twitter auth uid" do
      auth = mock_auth('twitter', nil, {nickname: 'alpha'})
      expect {
        User.create_with_omniauth(auth)
      }.to raise_error(Exceptions::AuthenticationFailureError)
    end
  end

  describe "finding a user by an omniauth provider info" do
    it "should find a user model by it's auth provider" do
      auth_1 = mock_auth('twitter', '2121', {nickname: 'alpha'})
      auth_2 = mock_auth('twitter', '8383', {nickname: 'bravo'})
      auth_3_user_not_created = mock_auth('twitter', '9999', {nickname: 'charlie'})
      User.create_with_omniauth(auth_1)
      User.create_with_omniauth(auth_2)

      expect(User.all.length).to eq(2)

      retrieved_user = User.find_by_omniauth(auth_1)
      expect(retrieved_user).to_not be_nil
      expect(retrieved_user.auth_provider.uid).to eq('2121')

      retrieved_user = User.find_by_omniauth(auth_2)
      expect(retrieved_user).to_not be_nil
      expect(retrieved_user.auth_provider.uid).to eq('8383')

      retrieved_user = User.find_by_omniauth(auth_3_user_not_created)
      expect(retrieved_user).to be_nil
    end
  end

  describe "scoring things" do
    before do
      @user = create(:user_alpha)
      @score_category = create(:score_category)
      @score = build(:score)
    end

    it "should allow the user to score a things" do
      expect(@user.scores.length).to eq(0)
      @user.create_score(@score)
      expect(@user.scores.length).to eq(1)
      expect(@user.scores.first).to eq(@score)
    end

    it "should not allow changing a score if the user doesn't own it" do
      other_user = create(:user_bravo)
      @user.create_score(@score)
      expect {
        other_user.change_score(@score, {points: 75})
      }.to raise_error(Exceptions::UnauthorizedModificationError)
    end
  end

  describe "adding/removing scores into score lists" do
    before do
      @user = create(:user_alpha)
    end

    describe "adding/removing scores into empty score lists" do
      it "should allow the user to create an empty score list" do
        expect(@user.score_lists.length).to eq(0)
        score_list = @user.create_score_list(name: 'Another Empty Score List')
        expect(@user.score_lists.length).to eq(1)
        expect(@user.score_lists.first).to eq(score_list)
        expect(@user.score_lists.first.scores.length).to eq(0)
      end

      it "should allow the user to add a score into an empty score list" do
        score = @user.create_score(build(:score))
        score_list = @user.create_score_list(name: 'An Empty Score List')

        expect(score_list.scores.length).to eq(0)
        @user.add_score_to_score_list(score_list, score)
        expect(score_list.scores.length).to eq(1)
      end
    end

    describe "automatically putting created scores into score lists" do
      it "should put a newly created score into a new score list" do
        expect(@user.score_lists.length).to eq(0)
        expect(@user.scores.length).to eq(0)

        score = @user.create_score(build(:score))
        expect(@user.score_lists.length).to eq(1)
        expect(@user.scores.length).to eq(1)

        expect(@user.score_lists.first.scores.length).to eq(1)
        expect(@user.score_lists.first.scores.first).to eq(score)
        expect(@user.scores.first.score_lists.length).to eq(1)
      end
    end

    describe "restricing access to adding/removing scores in score lists" do
      before do
        @other_user = create(:user_bravo)
        @other_user_score_list = @other_user.create_score_list(name: 'First Score List')
        @other_user_score = @other_user.create_score(build(:score))
      end

      it "should not allow a user to add their score to another user's score list" do
        score = @user.create_score(build(:score))

        expect {
          @user.add_score_to_score_list(@other_user_score_list, score)
        }.to raise_error(Exceptions::UnauthorizedModificationError)
      end

      it "should not allow a user to add another user's score to another user's score list" do
        expect {
          @user.add_score_to_score_list(@other_user_score_list, @other_user_score)
        }.to raise_error(Exceptions::UnauthorizedModificationError)
      end

      it "should not remove a score from another user's score list" do
        @other_user.add_score_to_score_list(@other_user_score_list, @other_user_score)
        expect(@other_user_score_list.scores.length).to eq(1)

        expect {
          @user.remove_score_from_score_list(@other_user_score_list, @other_user_score)
        }.to raise_error(Exceptions::UnauthorizedModificationError)
        expect(@other_user_score_list.scores.length).to eq(1)
      end
    end

    describe "removing a score from a score list" do
      before do
        @score_list = @user.create_score_list(name: 'My Scores For Patton Oswalt')
        @score = @user.create_score(build(:score))
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
    end
  end
end