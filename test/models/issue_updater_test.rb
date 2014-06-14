require 'test_helper'

class IssueImporterTest < ActiveSupport::TestCase

  def github_client
    @github_client ||= Octokit::Client.new(:access_token => "fake_access_token")
  end

  test "#from_issue updates issue on GitHub" do
    VCR.use_cassette "updates github issue" do
      updater = IssueUpdater.new(github_client)
      importer = IssueImporter.new(github_client)
      issue = issues(:issue3)
      issue.state = "closed"
      updater.from_issue(issue)
      importer.from_issue(issue)
      issue.reload
      assert_equal "closed", issue.state
    end
  end
end
