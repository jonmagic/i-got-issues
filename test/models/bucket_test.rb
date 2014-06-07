require 'test_helper'

class BucketTest < ActiveSupport::TestCase
  test "buckets are sortable" do
    current = buckets(:current)
    backlog = buckets(:backlog)
    icebox  = buckets(:icebox)
    assert_equal [current, backlog, icebox], Bucket.rank(:row_order).all

    current.change_position(:last)
    assert_equal [backlog, icebox, current], Bucket.rank(:row_order).all
  end
end
