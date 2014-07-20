require 'test_helper'

class TeamMembersFinderTest < ActiveSupport::TestCase
  include UserHelpers

  test "authorized user can find team members" do
    VCR.use_cassette method_name do
      team_members = TeamMembersFinder.process(user, {:team_id => 203770})

      assert team_members.any?
      assert_equal "jonmagic", team_members.first.login
    end
  end

  test "#user_write_permission? returns true when user is a team member" do
    VCR.use_cassette method_name do
      team = buckets(:current).team
      team_members_finder = TeamMembersFinder.new(user, {:team_id => team.id})

      assert team_members_finder.user_write_permission?
    end
  end

  test "#user_write_permission? returns false when user is not a team member" do
    VCR.use_cassette method_name do
      team = buckets(:unauthorized_write).team
      team_members_finder = TeamMembersFinder.new(user, {:team_id => team.id})

      refute team_members_finder.user_write_permission?
    end
  end
end
