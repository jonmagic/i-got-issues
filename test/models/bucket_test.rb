require 'test_helper'

class BucketTest < ActiveSupport::TestCase
  test "buckets are sortable" do
    assert Bucket.find_by_name("Current").row_order < Bucket.find_by_name("Backlog").row_order
    assert Bucket.find_by_name("Backlog").row_order < Bucket.find_by_name("Icebox").row_order
    Bucket.find_by_name("Backlog").update_attribute :row_order, 0
    assert Bucket.find_by_name("Backlog").row_order < Bucket.find_by_name("Current").row_order
    assert Bucket.find_by_name("Current").row_order < Bucket.find_by_name("Icebox").row_order
  end
end
