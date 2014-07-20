require 'test_helper'

class OrganizationsAndTeamsFinderTest < ActiveSupport::TestCase
  include UserHelpers

  test "user can find teams they belong to" do
    VCR.use_cassette method_name do
      teams_by_organization = OrganizationsAndTeamsFinder.process(user, {})
      hoytus = teams_by_organization.detect {|group| group.first == "hoytus" }
      when_apps = teams_by_organization.detect {|group| group.first == "when-apps" }

      assert_not_nil hoytus
      assert_not_nil when_apps

      team_b = hoytus.last.first
      owners = when_apps.last.first

      assert_equal "Team B", team_b.name
      assert_equal "Owners", owners.name
    end
  end
end
