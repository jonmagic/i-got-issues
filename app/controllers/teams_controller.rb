class TeamsController < ApplicationController
  def index
    @organizations = current_user.
      github_client.
      user_teams.
      map {|t| Team.new(t) }.
      group_by {|t| t.organization.downcase }.
      sort
  end

  # Archives all closed, non-archived issues for the current user.
  #
  # Note: In the future, when issues aren't limited to the user's team ID,
  # this will have to be scoped to the current team.
  def archive_closed_issues
    PrioritizedIssueArchiver.process(current_user, params)

    head :ok
  end
end
