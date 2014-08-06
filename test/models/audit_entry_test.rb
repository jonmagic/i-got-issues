require 'test_helper'

class AuditEntryTest < ActiveSupport::TestCase
  test "#team returns team with team_id" do
    entry = AuditEntry.new(:team_id => 1)

    assert_equal 1, entry.team.id
  end

  test "#team= sets team_id and team_name" do
    team       = Team.new(:id => 1, :name => "foo")
    entry      = AuditEntry.new
    entry.team = team

    assert_equal 1, entry.team_id
    assert_equal "foo", entry.team_name
  end

  test "#user= sets user_id and user_login" do
    user  = users(:jonmagic)
    entry = AuditEntry.new
    entry.user = user

    assert_equal user.id, entry.user_id
    assert_equal "jonmagic", entry.user_login
  end

  test "#action= does not allow unknown action" do
    entry = AuditEntry.new
    assert_raises(ArgumentError) { entry.action = :foo }
  end

  test "#issue_before_action sets a myriad of attributes" do
    pi    = prioritized_issues(:pi1)
    entry = AuditEntry.new
    entry.issue_before_action = pi

    assert_equal pi.issue.id, entry.issue_id
    assert_equal pi.issue.title, entry.issue_title
    assert_equal pi.id, entry.prioritized_issue_id
    assert_equal 1, entry.issue_start_position
    assert_equal pi.bucket.id, entry.source_bucket_id
    assert_equal pi.bucket.name, entry.source_bucket_name
  end

  test "#issue_after_action sets a few attributes" do
    pi    = prioritized_issues(:pi1)
    entry = AuditEntry.new
    entry.issue_after_action = pi

    assert_equal 1, entry.issue_end_position
    assert_equal pi.bucket.id, entry.target_bucket_id
    assert_equal pi.bucket.name, entry.target_bucket_name
  end

  test "#bucket_before_action= sets source bucket attributes" do
    bucket = buckets(:current)
    entry  = AuditEntry.new
    entry.bucket_before_action = bucket

    assert_equal bucket.id, entry.source_bucket_id
    assert_equal bucket.name, entry.source_bucket_name
    assert_equal 1, entry.bucket_start_position
  end

  test "#bucket_after_action= sets target bucket attributes" do
    bucket = buckets(:current)
    entry  = AuditEntry.new
    entry.bucket_after_action = bucket

    assert_equal bucket.id, entry.target_bucket_id
    assert_equal bucket.name, entry.target_bucket_name
    assert_equal 1, entry.bucket_end_position
  end
end
