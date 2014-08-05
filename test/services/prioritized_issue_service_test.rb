require 'test_helper'

class PrioritizedIssueServiceTest < ActiveSupport::TestCase
  def github_client
    @github_client ||= Octokit::Client.new(:access_token => TEST_ACCESS_TOKEN)
  end

  def user
    @user ||= begin
      user = users(:jonmagic)
      user.github_client = github_client
      user
    end
  end

  def team
    @team ||= Team.new(:id => 203770)
  end

  def service_for_user_and_team
    @service_for_user_and_team ||= \
      PrioritizedIssueService.for_user_and_team(user, team)
  end

  test "#import_issue_from_url imports issue and adds to team bucket" do
    VCR.use_cassette method_name do
      url    = "https://github.com/hoytus/acme/issues/2"
      bucket = buckets(:icebox)

      assert_difference("PrioritizedIssue.count", 1) do
        assert_difference("bucket.issues.count", 1) do
          service_for_user_and_team.import_issue_from_url(url)
        end
      end
    end
  end

  test "#for_prioritized_issue_by_id sets #prioritized_issue and returns self" do
    prioritized_issue = prioritized_issues(:pi1)
    service = service_for_user_and_team.for_prioritized_issue_by_id(prioritized_issue.id)

    assert_equal service_for_user_and_team, service
    assert_equal prioritized_issue, service.prioritized_issue
  end

  test "#update_issue_with_params updates issue and syncs change to GitHub" do
    VCR.use_cassette method_name do
      prioritized_issue = prioritized_issues(:pi3)
      params            = {:state => "closed"}

      assert_equal "open", prioritized_issue.issue.state

      service_for_user_and_team.
        for_prioritized_issue_by_id(prioritized_issue.id).
        update_issue_with_params(params)

      assert_equal "closed", service_for_user_and_team.prioritized_issue.issue.state
    end
  end

  test "#remove_prioritized_issue destroys the prioritized issue" do
    prioritized_issue = prioritized_issues(:pi3)

    service_for_user_and_team.
      for_prioritized_issue_by_id(prioritized_issue.id).
      remove_prioritized_issue

    refute service_for_user_and_team.prioritized_issue.persisted?
  end

  test "#move_prioritized_issue_to_position_in_bucket moves prioritized issue" do
    prioritized_issue = prioritized_issues(:pi3)
    bucket            = buckets(:current)
    service_for_user_and_team.for_prioritized_issue_by_id(prioritized_issue.id)

    assert_not_equal bucket, service_for_user_and_team.prioritized_issue.bucket
    service_for_user_and_team.move_prioritized_issue_to_position_in_bucket(0, bucket)
    assert_equal bucket, service_for_user_and_team.prioritized_issue.bucket
  end

  test "#update_issue_with_values_from_github updates issue with values from GitHub" do
    VCR.use_cassette method_name do
      prioritized_issue = prioritized_issues(:pi3)
      prioritized_issue.issue.update(:title => "foo")
      service_for_user_and_team.for_prioritized_issue_by_id(prioritized_issue.id)

      assert_equal "foo", prioritized_issue.issue.title
      service_for_user_and_team.update_issue_with_values_from_github
      assert_equal "It's dangerous to go alone. Take this!",
        service_for_user_and_team.prioritized_issue.issue.title
    end
  end
end
