require 'test_helper'

class IssueSyncTest < ActiveSupport::TestCase

  def github_client
    @github_client ||= Octokit::Client.new(:access_token => "fake_access_token")
  end

  test "from_url imports issue only once" do
    syncer = IssueSync.new(github_client)

    VCR.use_cassette "import from url" do
      assert_difference "Issue.count", 1 do
        syncer.from_url "https://github.com/jonmagic/scriptular/issues/10"
      end

      assert_difference "Issue.count", 0 do
        syncer.from_url "https://github.com/jonmagic/scriptular/issues/10"
      end
    end
  end

  test "from_issue syncs to github if synced_at is greater than updated_at" do
    syncer = IssueSync.new(github_client)
    issue = issues(:issue4)

    VCR.use_cassette "sync to github" do
      syncer.from_issue(issue)

      assert_equal issue.state, syncer.github_issue["state"]
    end
  end

  test "newer? returns false if new record" do
    syncer = IssueSync.new(github_client)
    syncer.set_issue = Issue.new
    refute syncer.newer?
  end

  test "newer? returns false issue.synced_at is blank" do
    syncer = IssueSync.new(github_client)
    syncer.set_issue = issues(:issue1)
    refute syncer.newer?
  end

  test "newer? returns false if issue.synced_at is older than github updated_at" do
    VCR.use_cassette "issue updated on github since last sync" do
      syncer = IssueSync.new(github_client)
      syncer.set_issue = issues(:issue3)
      refute syncer.newer?
    end
  end
end
