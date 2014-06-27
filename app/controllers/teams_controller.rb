class TeamsController < ApplicationController
  def index
    @organizations = current_user.
      github_client.
      user_teams.
      map {|t| Team.new(t) }.
      group_by {|t| t.organization.downcase }.
      sort
  end
end
