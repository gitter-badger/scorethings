require 'rails_helper'

RSpec.describe Thing do
  describe "validate things has external_id" do
    it "should require an external_id if it is a YOUTUBE_VIDEO" do
      thing = build(:thing, :youtube_video)
      thing.external_id = nil
      expect(thing.valid?).to be false
    end

    it "should require an external_id if it is a TWITTER_ACCOUNT" do
      thing = build(:thing, :twitter_account)
      thing.external_id = nil
      expect(thing.valid?).to be false
    end

    it "should require an external_id if it is a TWITTER_TWEET" do
      thing = build(:thing, :twitter_tweet)
      thing.external_id = nil
      expect(thing.valid?).to be false
    end

    it "should NOT require an external_id if it is a HASHTAG" do
      thing = build(:thing, :hashtag)
      thing.external_id = nil
      expect(thing.valid?).to be true
    end
  end
end