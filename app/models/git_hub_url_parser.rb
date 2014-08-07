class GitHubUrlParser
  class InvalidUrl < StandardError; end

  def initialize(url)
    @matches = url_pattern.match(url)
    raise InvalidUrl unless @matches.present?
  end

  attr_reader :matches

  def owner
    matches[1]
  end

  def repository
    matches[2]
  end
end
