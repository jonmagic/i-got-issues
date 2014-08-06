require 'test_helper'

class BucketTest < ActiveSupport::TestCase
  test "buckets are sortable" do
    current = buckets(:current)
    backlog = buckets(:backlog)
    icebox  = buckets(:icebox)
    team = Team.new(:id => current.team_id)
    assert_equal [current, backlog, icebox], team.buckets.all

    current.change_position(:last)
    assert_equal [backlog, icebox, current], team.buckets.all
  end

  test "#current_position returns column position" do
    assert_equal 1, buckets(:current).current_position
    assert_equal 2, buckets(:backlog).current_position
    assert_equal 3, buckets(:icebox).current_position
  end
end
