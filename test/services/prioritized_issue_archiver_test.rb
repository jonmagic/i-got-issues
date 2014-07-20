require 'test_helper'

class PrioritizedIssueArchiverTest < ActiveSupport::TestCase
  include UserHelpers

  test "team member can archive issues" do
    VCR.use_cassette method_name do
      issue = prioritized_issues(:pi4)
      params = {
        :team_id => 203770 # member of https://github.com/orgs/hoytus/teams/team-b
      }

      refute issue.archived?

      PrioritizedIssueArchiver.process(user, params)
      issue.reload

      assert issue.archived?
    end
  end

  test "non-team member cannot archive issues" do
    VCR.use_cassette method_name do
      params = {
        :team_id => 203768 # not a member of https://github.com/orgs/hoytus/teams/owners
      }

      assert_raises(NotAuthorized) { PrioritizedIssueArchiver.process(user, params) }
    end
  end
end
