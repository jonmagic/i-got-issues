require 'test_helper'

class TeamFinderTest < ActiveSupport::TestCase
  include UserHelpers

  test "authorized user can find team" do
    VCR.use_cassette method_name do
      bucket = buckets(:current)
      team = TeamFinder.process(user, {:team_id => bucket.team_id})

      assert_equal bucket.team_id, team.id
      assert_equal "Team B", team.name
      assert_equal "hoytus", team.organization
    end
  end
end
