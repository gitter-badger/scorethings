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
  end
end
