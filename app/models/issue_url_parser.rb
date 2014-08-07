class IssueUrlParser < GitHubUrlParser
  def url_pattern
    /https?\:\/\/github\.(?:com|dev)\/(.+)\/(.+)\/(?:issues|pull)\/(\d*)/
  end

  def number
    matches[3].to_i
  end
end
