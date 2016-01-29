require 'test_helper'

class IssueImporterTest < ActiveSupport::TestCase

  def github_client
    @github_client ||= Octokit::Client.new(:access_token => TEST_ACCESS_TOKEN)
  end

  test "#from_url imports new issue" do
    VCR.use_cassette method_name do
      importer = IssueImporter.new(github_client)
      issue = nil

      assert_difference "Issue.count", 1 do
        issue = importer.from_url "https://github.com/octokit/octokit.rb/issues/3"
      end

      assert_equal "list_commits does not return commits for private repos", issue.title
      assert_equal nil, issue.assignee
      assert_equal [], issue.labels
    end
  end

  test "#from_url updates existing issue" do
    VCR.use_cassette method_name do
      importer = IssueImporter.new(github_client)
      issue = issues(:issue1)

      assert_equal "fix the copy", issue.title
      assert_equal "jonmagic", issue.assignee
      assert_equal "open", issue.state
      assert_equal ["bug"], issue.labels
      issue = importer.from_url "https://github.com/jonmagic/scriptular/issues/10"
      assert_equal "Add share-able link to output section", issue.title
      assert_equal nil, issue.assignee
      assert_equal "closed", issue.state
      assert_equal [], issue.labels
    end
  end

  test "#from_issue updates issue when modified since updated_at" do
    VCR.use_cassette method_name do
      importer = IssueImporter.new(github_client)
      issue = issues(:issue1)

      assert_equal "fix the copy", issue.title
      assert_equal "jonmagic", issue.assignee
      assert_equal "open", issue.state
      assert_equal ["bug"], issue.labels
      issue = importer.from_issue issue
      assert_equal "Add share-able link to output section", issue.title
      assert_equal nil, issue.assignee
      assert_equal "closed", issue.state
      assert_equal [], issue.labels
    end
  end

  test "#from_issue does not update issue when github returns 304 not modified" do
    VCR.use_cassette method_name do
      importer = IssueImporter.new(github_client)
      issue = issues(:issue1)
      # remote issue Last-Modified is Fri, 15 Jan 2016 10:16:22 GMT
      # update local issue to have updated_at after that date
      updated_at = Time.parse("2016-01-17")
      issue.update_attribute(:updated_at, updated_at)
      issue = importer.from_issue issue.reload

      assert_equal updated_at, issue.updated_at
    end
  end
end
