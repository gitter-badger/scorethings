require 'rails_helper'

RSpec.describe Thing do
  describe "validate thing has external_id" do
    it "should require an external_id if it is a YOUTUBE_VIDEO" do
      youtube_thing = build(:youtube_video_thing)
      expect(youtube_thing.valid?).to be true

      youtube_thing.external_id = nil
      expect(youtube_thing.valid?).to be false
    end

    it "should require an external_id if it is a TWITTER_ACCOUNT" do
      twitter_account_thing = build(:twitter_account_thing)
      expect(twitter_account_thing.valid?).to be true

      twitter_account_thing.external_id = nil
      expect(twitter_account_thing.valid?).to be false
    end

    it "should not require an external_id if it is a HASHTAG" do
      hashtag_thing = build(:hashtag_thing)
      expect(hashtag_thing.valid?).to be true

      hashtag_thing.external_id = nil
      expect(hashtag_thing.valid?).to be true
    end
  end
end