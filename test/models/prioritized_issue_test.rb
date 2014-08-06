require 'test_helper'

class PrioritizedIssueTest < ActiveSupport::TestCase
  test "reorder issues in a bucket" do
    pi1 = prioritized_issues(:pi1)
    pi3 = prioritized_issues(:pi3)
    icebox = buckets(:icebox)

    pi1.change_position(2)
    assert_equal [pi3, pi1], PrioritizedIssue.bucket(icebox).all
  end

  test "move issue to different bucket and change priority" do
    pi1 = prioritized_issues(:pi1)
    pi2 = prioritized_issues(:pi2)
    backlog = buckets(:backlog)

    assert_equal "Icebox", pi1.bucket.name

    pi1.move_to_bucket backlog, :first

    assert_equal "Backlog", pi1.bucket.name
    assert_equal [pi1, pi2], PrioritizedIssue.bucket(backlog).all
  end

  test "#current_position returns position of issue in bucket" do
    assert_equal 1, prioritized_issues(:pi1).current_position
    assert_equal 2, prioritized_issues(:pi3).current_position
  end
end
