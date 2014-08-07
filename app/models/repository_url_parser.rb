class RepositoryUrlParser < GitHubUrlParser
  def url_pattern
    /https?\:\/\/github\.(?:com|dev)\/(.+)\/(.+)/
  end
end
