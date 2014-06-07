require 'test_helper'

class UrlParserTest < ActiveSupport::TestCase
  test "raises error if the url does not match pattern" do
    assert_raises(UrlParser::InvalidUrl) { UrlParser.new("foo") }
  end

  test "#github_owner" do
    parsed  = UrlParser.new("https://github.com/jonmagic/scriptular/issues/1")
    assert_equal "jonmagic", parsed.github_owner
  end

  test "#github_repository" do
    parsed  = UrlParser.new("https://github.com/jonmagic/scriptular/issues/1")
    assert_equal "scriptular", parsed.github_repository
  end

  test "#github_id" do
    parsed  = UrlParser.new("https://github.com/jonmagic/scriptular/issues/1")
    assert_equal 1, parsed.github_id
  end
end
