require 'test_helper'

class BucketServiceTest < ActiveSupport::TestCase
  test "creates bucket for team using params" do
    team = Team.new(:id => 203770)

    bucket = BucketService.create(team, {:name => "Backlog"})
    bucket.reload

    assert_equal "Backlog", bucket.name
  end

  test "updates bucket name and row_order from params" do
    bucket = buckets(:current)
    BucketService.new(bucket.id).update({:name => "Icebox", :row_order_position => 1})
    bucket.reload

    assert_equal "Icebox", bucket.name
    assert_equal 1, bucket.row_order
  end

  test "does not update bucket team from params" do
    bucket = buckets(:current)
    BucketService.new(bucket.id).update({:team_id => 1})
    bucket.reload

    assert_equal 203770, bucket.team_id
  end

  test "destroys bucket" do
    bucket = buckets(:current)

    assert_difference "Bucket.count", -1 do
      BucketService.new(bucket.id).destroy
    end
  end

  test "assigns issues to other bucket before destroy" do
    bucket             = buckets(:icebox)
    destination_bucket = buckets(:backlog)

    assert_equal 2, bucket.issues.count

    assert_difference "destination_bucket.issues.count", 2 do
      BucketService.new(bucket.id).destroy
    end
  end
end
