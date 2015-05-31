require 'rails_helper'

RSpec.describe TwitterService do
  before do
    @twitter_service = TwitterService.new
  end

  describe "searching for twitter accounts" do
    before do
      @twitter_account = Twitter::User.new(
          id: 11111,
          screen_name: 'pattonoswalt',
          name: 'Patton Oswalt',
          verified: true,
          uri: Addressable::URI.parse('https://twitter.com/pattonoswalt'))
    end

    it "should search for a twitter account" do
      allow_any_instance_of(Twitter::REST::Client).to receive(:user_search).with('pattonoswalt')
                                                          .and_return([@twitter_account])

      search_results = @twitter_service.search_twitter_account_web_things('pattonoswalt')

      expect(search_results).to_not be_nil

      search_result = search_results[0]
      expect(search_result).to_not be_nil
      expect(search_result.external_id).to eq(11111)
      expect(search_result.title).to eq('@pattonoswalt')
      expect(search_result.secondary_title).to eq('Patton Oswalt')
      expect(search_result.uri).to eq('https://twitter.com/pattonoswalt')
      expect(search_result.verified).to be true
    end

    it "should search for a twitter account with the account uri" do
      allow_any_instance_of(Twitter::REST::Client).to receive(:user).with('https://twitter.com/pattonoswalt')
                                                          .and_return([@twitter_account])

      search_results = @twitter_service.search_twitter_account_web_things('https://twitter.com/pattonoswalt')

      expect(search_results).to_not be_nil

      search_result = search_results[0]
      expect(search_result).to_not be_nil
      expect(search_result.external_id).to eq(11111)
      expect(search_result.title).to eq('@pattonoswalt')
      expect(search_result.secondary_title).to eq('Patton Oswalt')
      expect(search_result.uri).to eq('https://twitter.com/pattonoswalt')
      expect(search_result.verified).to be true
    end

    it "should return empty results if searching with uri with no account" do
      allow_any_instance_of(Twitter::REST::Client).to receive(:user).with('https://twitter.com/supercoolpattonoswalt')
                                                          .and_raise(Twitter::Error::NotFound)
      search_results = @twitter_service.search_twitter_account_web_things('https://twitter.com/supercoolpattonoswalt')
      expect(search_results).to eq([])
    end

    it "should raise search error when too many twitter requests" do
      allow_any_instance_of(Twitter::REST::Client).to receive(:user_search).with('pattonoswalt')
                                                          .and_raise(Twitter::Error::TooManyRequests)
      expect {
        @twitter_service.search_twitter_account_web_things('pattonoswalt')
      }.to raise_error(Exceptions::WebThingExternalError)
    end
  end
end
