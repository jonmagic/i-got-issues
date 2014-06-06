require 'test_helper'

class IssueTest < ActiveSupport::TestCase
  test "#state returns nil when not set" do
    assert_nil Issue.new.state
  end

  test "#state returns :open when set to open" do
    issue = Issue.new :state => :open
    assert_equal "open", issue.state
  end
end
