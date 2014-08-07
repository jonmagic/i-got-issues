require 'test_helper'

class RepositoryUrlParserTest < ActiveSupport::TestCase
  test "raises error if the url does not match pattern" do
    assert_raises(RepositoryUrlParser::InvalidUrl) { RepositoryUrlParser.new("foo") }
  end

  test "works with pull request url" do
    assert_nothing_raised { RepositoryUrlParser.new("https://github.com/jonmagic/scriptular") }
  end

  test "#owner" do
    parsed  = RepositoryUrlParser.new("https://github.com/jonmagic/scriptular")
    assert_equal "jonmagic", parsed.owner
  end

  test "#repository" do
    parsed  = RepositoryUrlParser.new("https://github.com/jonmagic/scriptular")
    assert_equal "scriptular", parsed.repository
  end
end
