require 'test_helper'

class BucketServiceTest < ActiveSupport::TestCase
  def user
    @user ||= users(:jonmagic)
  end

  def team
    @team ||= Team.new(:id => 203770)
  end

  def service_for_user_and_team
    @service_for_user_and_team ||= BucketService.for_user_and_team(user, team)
  end

  test "#for_bucket_by_id finds bucket for team and sets on service" do
    bucket = buckets(:current)
    service_for_user_and_team.for_bucket_by_id(bucket.id)

    assert_equal bucket, service_for_user_and_team.bucket
  end

  test "#for_bucket_by_id raises ActiveRecord::RecordNotFound if bucket does not belong to team" do
    bucket = buckets(:other)

    assert_raises(ActiveRecord::RecordNotFound) do
      service_for_user_and_team.for_bucket_by_id(bucket.id)
    end
  end

  test "#create_bucket_with_params creates bucket for team using params" do
    assert_difference("Bucket.count", 1) do
      assert_difference("team.buckets.count", 1) do
        service_for_user_and_team.create_bucket_with_params({:name => "Foo"})
      end
    end

    assert_equal "Foo", service_for_user_and_team.bucket.name
  end

  test "#update_bucket_with_params updates bucket name and row_order from params" do
    bucket = buckets(:current)

    service_for_user_and_team.
      for_bucket_by_id(bucket.id).
      update_bucket_with_params({:name => "Icebox", :row_order_position => 1})

    assert_equal "Icebox", service_for_user_and_team.bucket.name
    assert_equal 1, service_for_user_and_team.bucket.row_order
  end

  test "#update_bucket_with_params does not update bucket team from params" do
    bucket = buckets(:current)

    service_for_user_and_team.
      for_bucket_by_id(bucket.id).
      update_bucket_with_params({:team_id => 1})

    assert_equal 203770, bucket.reload.team_id
  end

  test "#move_issues_and_remove_bucket removes bucket" do
    bucket = buckets(:current)
    service_for_user_and_team.for_bucket_by_id(bucket.id)

    assert_difference "Bucket.count", -1 do
      service_for_user_and_team.move_issues_and_remove_bucket
    end
  end

  test "#move_issues_and_remove_bucket moves issues to another bucket before removing" do
    bucket             = buckets(:icebox)
    destination_bucket = buckets(:backlog)
    service_for_user_and_team.for_bucket_by_id(bucket.id)

    assert_equal 2, bucket.issues.count

    assert_difference "destination_bucket.issues.count", 2 do
      service_for_user_and_team.move_issues_and_remove_bucket
    end
  end
end
