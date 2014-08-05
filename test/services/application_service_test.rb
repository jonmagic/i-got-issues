require 'test_helper'

class ApplicationServiceTest < ActiveSupport::TestCase
  test ".for_user_and_team returns instance with user and team set" do
    user    = User.new
    team    = Team.new
    service = ApplicationService.for_user_and_team(user, team)

    assert_equal user, service.user
    assert_equal team, service.team
  end

  test "#github_client returns github client for user" do
    user               = User.new
    user.github_client = "fake github client"
    team               = Team.new
    service            = ApplicationService.for_user_and_team(user, team)

    assert_equal "fake github client", service.github_client
  end
end
