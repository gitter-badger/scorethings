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
      @user = create(:user)
      @score_category = create(:score_category)
      @score = build(:score)
    end

    it "should allow the user to score a things" do
      expect(@user.scores.length).to eq(0)
      @user.create_score(@score)
      expect(@user.scores.length).to eq(1)
      expect(@user.scores.first).to eq(@score)
    end

    describe "updating a score" do
      it "should update a score" do
        @user.create_score(@score)
        @user.update_points(@score, 33)
        @score.reload
        expect(@score.points).to eq(33)
      end

      it "should not allow updating a score if the user doesn't own it" do
        other_user = create(:user)
        @user.create_score(@score)
        expect {
          other_user.update_points(@score, 75)
        }.to raise_error(Exceptions::UnauthorizedModificationError)
      end
    end

    it "should not have more than one score with the same user, score cateogry and thing" do
      @user.create_score(@score)
      other_score = build(:score, thing: @score.thing, score_category: @score.score_category)

      expect(Score.all.length).to eq(1)
      expect {
        @user.create_score(other_score)
      }.to raise_error(Exceptions::ScoreUniquenessError)
      expect(Score.all.length).to eq(1)

      other_score.thing = create(:thing)
      @user.create_score(other_score)
      expect(Score.all.length).to eq(2)
    end
  end
end