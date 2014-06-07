class UrlParser
  ISSUE_REGEX = /https?\:\/\/github\.(?:com|dev)\/(.+)\/(.+)\/issues\/(\d*)/

  def initialize(url)
    @matches = ISSUE_REGEX.match(url)
    raise StandardError unless @matches.present?
  end

  attr_reader :matches

  def github_owner
    matches[1]
  end

  def github_repository
    matches[2]
  end

  def github_id
    matches[3].to_i
  end
end
