require 'rails_helper'

RSpec.describe ThingService do
  before do
    @thing_service = ThingService.new
    Rails.cache.clear
  end

  describe "autocomplete twitter account" do
    it "should return a list of twitter account suggestions with input without @ character" do
      pattonoswalt_user = Twitter::User.new(
          id: 11111,
          screen_name: 'pattonoswalt',
          name: 'Patton Oswalt',
          uri: Addressable::URI.parse('https://twitter.com/pattonoswalt'))
      # FIXME for some reason, I need to use the profile_image_url= method to set the image url
      jeffpatton_user = Twitter::User.new(
          id: 22222,
          screen_name: 'jeffpatton',
          name: 'Jeff Patton',
          uri: Addressable::URI.parse('https://twitter.com/jeffpatton'))
      # FIXME for some reason, I need to use the profile_image_url= method to set the image url
      # can't test Twitter::User profile_image_uri -> image_uri

      allow_any_instance_of(TwitterService).to receive(:search_for_twitter_accounts).with('patton').and_return([pattonoswalt_user, jeffpatton_user])
      results = @thing_service.search(Scorethings::ThingTypes::TWITTER_ACCOUNT, 'patton')
      expect(results).to_not be_nil
      expect(results.length).to eq(2)

      expect(results[0].external_id).to eq('11111')
      expect(results[0].title).to eq('@pattonoswalt (Patton Oswalt)')
      expect(results[0].uri).to eq('https://twitter.com/pattonoswalt')

      expect(results[1].external_id).to eq('22222')
      expect(results[1].title).to eq('@jeffpatton (Jeff Patton)')
      expect(results[1].uri).to eq('https://twitter.com/jeffpatton')
    end
  end
end
