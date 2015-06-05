require 'rails_helper'

RSpec.describe GithubService do
  before do
    @github_service = GithubService.new
    @github_repository = {:id=>32635915,
                          :name=>"scorethings",
                          :full_name=>"manuisfunny/scorethings",
                          :owner=>
                              {:login=>"manuisfunny",
                               :id=>11468064,
                               :avatar_url=>"https://avatars.githubusercontent.com/u/11468064?v=3",
                               :type=>"User",
                               :site_admin=>false},
                          :html_url=>"https://github.com/manuisfunny/scorethings",
                          :description=>"Helping users score things",
                          :url=>"https://api.github.com/repos/manuisfunny/scorethings",
                          :homepage=>"http://www.scorethings.com"}

    @github_repository_search_result =
                        {:id=>32635915,
                          :name=>"scorethings",
                          :owner=> "manuisfunny",
                          :url =>"https://github.com/manuisfunny/scorethings",
                          :description=>"Helping users score things",
                          :homepage=>"http://www.scorethings.com"}

    @github_repository_search_response = [@github_repository_search_result]
  end

  describe "searching for github repository" do
    it "should search for a github repository" do
      allow_any_instance_of(Octokit::Client).to receive(:legacy_search_repositories).with('scorethings')
                                                          .and_return(@github_repository_search_response)

      search_results = @github_service.search_github_repository_things('scorethings')

      expect(search_results).to_not be_nil
      expect(search_results.length).to eq(1)

      search_result = search_results[0]
      expect(search_result).to_not be_nil
      expect(search_result.external_id).to eq('manuisfunny/scorethings')
      expect(search_result.title).to eq('manuisfunny/scorethings')
      # the github search results don't have image urls
      expect(search_result.image_uri).to be_nil
      expect(search_result.uri).to eq('https://github.com/manuisfunny/scorethings')
    end

    it "should search for a github repository by owner/repo_name by simply getting it" do
      # because the query is owner/repo, the github service will just get it, not search
      allow_any_instance_of(Octokit::Client).to receive(:repo).with('manuisfunny/scorethings')
                                                    .and_return(@github_repository)

      search_results = @github_service.search_github_repository_things('manuisfunny/scorethings')

      expect(search_results).to_not be_nil
      expect(search_results.length).to eq(1)

      search_result = search_results[0]
      expect(search_result).to_not be_nil
      expect(search_result.external_id).to eq('manuisfunny/scorethings')
      expect(search_result.title).to eq('manuisfunny/scorethings')
      expect(search_result.image_uri).to eq('https://avatars.githubusercontent.com/u/11468064?v=3')
      expect(search_result.uri).to eq('https://github.com/manuisfunny/scorethings')
    end

    it "should return nothing when no github repositories are found" do
      allow_any_instance_of(Octokit::Client).to receive(:legacy_search_repositories).with('scorethings')
                                                          .and_raise(Octokit::NotFound)
      search_results = @github_service.search_github_repository_things('scorethings')
      expect(search_results).to eq([])
    end
  end

  describe "getting a github repository thing" do
    it "should get a github repository thing" do
      allow_any_instance_of(Octokit::Client).to receive(:repo).with('manuisfunny/scorethings')
                                                    .and_return(@github_repository)
      thing = @github_service.get_github_repository_thing('manuisfunny/scorethings')
      expect(thing).to_not be_nil
      expect(thing.external_id).to eq('manuisfunny/scorethings')
      expect(thing.title).to eq('manuisfunny/scorethings')
      expect(thing.image_uri).to eq('https://avatars.githubusercontent.com/u/11468064?v=3')
      expect(thing.uri).to eq('https://github.com/manuisfunny/scorethings')
    end

    it "should raise an error if thing cannot be retrieved" do
      allow_any_instance_of(Octokit::Client).to receive(:repo).with('manuisfunny/scorethings')
                                                    .and_raise(Octokit::NotFound)

      expect {
        @github_service.get_github_repository_thing('manuisfunny/scorethings')
      }.to raise_error(Exceptions::ThingNotFoundError)
    end
  end
end
