require 'rails_helper'

RSpec.describe ScoreList do
  # TODO clean up similar specs to keep things DRY (Don't Repeat Yourself)
  before do
    @user = create(:user_alpha)
    @user.initialize_points_balance
  end

  describe "creating a score list from a twitter member list" do
    it "should create a new score list with new scores because user had not creating them before" do
      @user.create_score(thing_type: 'TWITTER_UID', thing_value: '99999')
      expect(@user.scores.length).to eq(1)

      twitter_accounts = []
      (1..5).step(1) do |n|
        # FIXME figure out how twitter accounts are structured
        # maybe may the twitter api class to a simple thing with uid or
        # hashtag (or tweet id in future when tweets are things)
        twitter_accounts << {twitter_uid: (1000 + n)}
      end
      score_list = ScoreList.build_from_twitter_list(@user, 'Cool Hackers', twitter_accounts)
      expect(score_list).to_not be_nil
      expect(@user.scores.length).to eq(6)
      expect(score_list.name).to eq('Cool Hackers')
      expect(score_list.user).to eq(@user)
    end

    it "should create a new score list with some existing scores because user had creating them before" do
      @user.create_score(thing_type: 'TWITTER_UID', thing_value: '1002')
      expect(@user.scores.length).to eq(1)

      twitter_accounts = []
      (1..5).step(1) do |n|
        # FIXME figure out how twitter accounts are structured
        # maybe may the twitter api class to a simple thing with uid or
        # hashtag (or tweet id in future when tweets are things)
        twitter_accounts << {twitter_uid: (1000 + n)}
      end
      score_list = ScoreList.build_from_twitter_list(@user, 'Cool Hackers', twitter_accounts)
      expect(score_list).to_not be_nil
      expect(@user.scores.length).to eq(5)
      expect(score_list.name).to eq('Cool Hackers')
      expect(score_list.user).to eq(@user)
    end
  end
end