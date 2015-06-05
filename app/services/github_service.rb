class GithubService
  def search_github_repository_things(query)
    # FIXME uses legacy search, allowing for query qualifiers
    # ex: https://api.github.com/search/repositories?q=tetris+language:assembly&sort=stars&order=desc
    # should ensure query isn't a security hole
    # https://developer.github.com/v3/search/

    begin
      if query.match(/^.*\/.*$/)
        owner_repo_name = query
        return [get_github_repository_thing(owner_repo_name)]
      end
      search_results = $github.legacy_search_repositories(query)

      return search_results.map do |search_result|
        map_github_repository_search_result_to_thing(search_result)
      end
    rescue Octokit::NotFound
      return []
    end
  end

  def get_github_repository_thing(owner_repo_name)
    begin
      repository = $github.repo(owner_repo_name)
      return map_github_repository_to_thing(repository)
    rescue Octokit::NotFound
      raise Exceptions::ThingNotFoundError
    end
  end

  private
  def map_github_repository_to_thing(repository)
    Thing.new(
        title: repository[:full_name],
        external_id: repository[:full_name],
        uri: repository[:html_url],
        image_uri: repository[:owner][:avatar_url],
        type: Scorethings::ThingTypes::GITHUB_REPOSITORY)
  end

  def map_github_repository_search_result_to_thing(repository_search_result)
    puts "\n\nrepo: #{repository_search_result}"
    full_name = "#{repository_search_result[:owner]}/#{repository_search_result[:name]}"
    Thing.new(
        title: full_name,
        external_id: full_name,
        uri: repository_search_result[:url],
        image_uri: nil,
        type: Scorethings::ThingTypes::GITHUB_REPOSITORY)
  end
end
