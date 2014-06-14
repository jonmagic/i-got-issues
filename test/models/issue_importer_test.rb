require 'test_helper'

class IssueImporterTest < ActiveSupport::TestCase

  def github_client
    @github_client ||= Octokit::Client.new(:access_token => "fake_access_token")
  end

  test "#from_url imports new issue" do
    VCR.use_cassette "imports new issue" do
      importer = IssueImporter.new(github_client)

      assert_difference "Issue.count", 1 do
        importer.from_url "https://github.com/octokit/octokit.rb/issues/3"
      end

      issue = Issue.by_owner_repo_number("octokit", "octokit.rb", 3).first
      assert_equal "list_commits does not return commits for private repos", issue.title
      assert_equal nil, issue.assignee
      assert_equal [], issue.labels
    end
  end

  test "#from_url updates existing issue" do
    VCR.use_cassette "updates existing issue" do
      importer = IssueImporter.new(github_client)
      issue = issues(:issue1)

      assert_equal "fix the copy", issue.title
      assert_equal "jonmagic", issue.assignee
      assert_equal "open", issue.state
      assert_equal ["bug"], issue.labels
      importer.from_url "https://github.com/jonmagic/scriptular/issues/10"
      issue.reload
      assert_equal "Add share-able link to output section", issue.title
      assert_equal nil, issue.assignee
      assert_equal "closed", issue.state
      assert_equal [], issue.labels
    end
  end

  test "#from_issue updates existing issue" do
    VCR.use_cassette "updates existing issue" do
      importer = IssueImporter.new(github_client)
      issue = issues(:issue1)

      assert_equal "fix the copy", issue.title
      assert_equal "jonmagic", issue.assignee
      assert_equal "open", issue.state
      assert_equal ["bug"], issue.labels
      importer.from_issue issue
      issue.reload
      assert_equal "Add share-able link to output section", issue.title
      assert_equal nil, issue.assignee
      assert_equal "closed", issue.state
      assert_equal [], issue.labels
    end
  end
end
