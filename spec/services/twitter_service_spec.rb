require 'rails_helper'

RSpec.describe TwitterService do
  before do
    @twitter_service = TwitterService.new
    Rails.cache.clear
  end

  # FIXME I need to understand how to test with mock Twitter::SearchResults
  # there should be tests for searching and mapping the results
  # at least, make the mapping methods public to be able to test it in isolation
  # promise, I'll figure it out, I'm just in a rush right now
  describe "mapping twitter resources to things" do
    before do
      @pattonoswalt_user = Twitter::User.new(
          id: 11111,
          screen_name: 'pattonoswalt',
          name: 'Patton Oswalt',
          verified: true,
          uri: Addressable::URI.parse('https://twitter.com/pattonoswalt'))
    end
    it "should map a twitter user account to a thing" do
      # FIXME for some reason, I need to use the profile_image_url= method to set the image url
      # can't test Twitter::User profile_image_uri -> image_uri
      twitter_account_thing = @twitter_service.map_user_to_thing(@pattonoswalt_user)
      expect(twitter_account_thing).to_not be_nil

      expect(twitter_account_thing.external_id).to eq('11111')
      expect(twitter_account_thing.title).to eq('@pattonoswalt (Patton Oswalt)')
      expect(twitter_account_thing.uri).to eq('https://twitter.com/pattonoswalt')
      expect(twitter_account_thing.verified).to be true
    end

    xit "should map a twitter tweet to a thing" do
      # FIXME for some reason, I'm not able to get the Twitter::User in the Twitter::Tweet
      # need to figure that out
      created_at_time = Time.now
      funny_tweet = Twitter::Tweet.new(
          id: 212121,
          uri: Addressable::URI.parse('https://twitter.com/pattonoswalt/status/600803460729057280'),
          created_at: created_at_time,
          text: 'Something something funny.  LOL.')
      funny_tweet.user = @pattonoswalt_user
      # FIXME for some reason, I need to use the profile_image_url= method to set the image url
      # can't test Twitter::User profile_image_uri -> image_uri
      twitter_tweet_thing = @twitter_service.map_tweet_to_thing(funny_tweet)
      expect(twitter_tweet_thing).to_not be_nil

      expect(funny_tweet.external_id).to eq('212121')
      expect(funny_tweet.title).to eq('tweet from @pattonoswalt at 2015-05-19 23:21:22 +0000')
      expect(funny_tweet.uri).to eq('https://twitter.com/pattonoswalt/status/600803460729057280')
      expect(funny_tweet.verified).to be true
    end
  end
end
