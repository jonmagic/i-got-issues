require 'test_helper'

class UrlParserTest < ActiveSupport::TestCase
  test "raises error if the url does not match pattern" do
    assert_raises(UrlParser::InvalidUrl) { UrlParser.new("foo") }
  end

  test "works with pull request url" do
    assert_nothing_raised { UrlParser.new("https://github.com/jonmagic/scriptular/pull/33") }
  end

  test "#owner" do
    parsed  = UrlParser.new("https://github.com/jonmagic/scriptular/issues/1")
    assert_equal "jonmagic", parsed.owner
  end

  test "#repository" do
    parsed  = UrlParser.new("https://github.com/jonmagic/scriptular/issues/1")
    assert_equal "scriptular", parsed.repository
  end

  test "#number" do
    parsed  = UrlParser.new("https://github.com/jonmagic/scriptular/issues/1")
    assert_equal 1, parsed.number
  end
end
