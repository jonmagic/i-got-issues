require 'test_helper'

class BucketServiceTest < ActiveSupport::TestCase
  def team
    @team ||= Team.new(:id => 203770)
  end

  test "creates bucket for team using params" do
    bucket = BucketService.create(team, {:name => "Backlog"})
    bucket.reload

    assert_equal "Backlog", bucket.name
  end

  test "raises ActiveRecord::RecordNotFound if bucket does not belong to team" do
    team   = Team.new(:id => 203768)
    bucket = buckets(:current)

    bucket_service = BucketService.new(team, bucket.id)

    assert_raises(ActiveRecord::RecordNotFound) do
      bucket_service.bucket
    end
  end

  test "updates bucket name and row_order from params" do
    bucket = buckets(:current)
    BucketService.new(team, bucket.id).update({:name => "Icebox", :row_order_position => 1})
    bucket.reload

    assert_equal "Icebox", bucket.name
    assert_equal 1, bucket.row_order
  end

  test "does not update bucket team from params" do
    bucket = buckets(:current)
    BucketService.new(team, bucket.id).update({:team_id => 1})
    bucket.reload

    assert_equal 203770, bucket.team_id
  end

  test "destroys bucket" do
    bucket = buckets(:current)

    assert_difference "Bucket.count", -1 do
      BucketService.new(team, bucket.id).destroy
    end
  end

  test "assigns issues to other bucket before destroy" do
    bucket             = buckets(:icebox)
    destination_bucket = buckets(:backlog)

    assert_equal 2, bucket.issues.count

    assert_difference "destination_bucket.issues.count", 2 do
      BucketService.new(team, bucket.id).destroy
    end
  end
end
