class UrlParser
  class InvalidUrl < StandardError; end

  ISSUE_REGEX = /https?\:\/\/github\.(?:com|dev)\/(.+)\/(.+)\/issues\/(\d*)/

  def initialize(url)
    @matches = ISSUE_REGEX.match(url)
    raise InvalidUrl unless @matches.present?
  end

  attr_reader :matches

  def owner
    matches[1]
  end

  def repository
    matches[2]
  end

  def number
    matches[3].to_i
  end
end
