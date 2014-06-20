require 'test_helper'

class BucketTest < ActiveSupport::TestCase
  test "buckets are sortable" do
    current = buckets(:current)
    backlog = buckets(:backlog)
    icebox  = buckets(:icebox)
    team = Team.new(current.team_id)
    assert_equal [current, backlog, icebox], team.buckets.all

    current.change_position(:last)
    assert_equal [backlog, icebox, current], team.buckets.all
  end
end
