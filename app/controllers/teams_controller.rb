class TeamsController < ApplicationController
  before_filter :authorize_write_team!, :only => [:archive_closed_issues]
  after_filter  :notify_team_subscribers, :only => [:archive_closed_issues]

  def index
    @organizations = current_user.
      github_client.
      user_teams.
      map {|t| Team.new(t) }.
      group_by {|t| t.organization.downcase }.
      sort
  end

  # Archives all closed, non-archived issues for the team.
  def archive_closed_issues
    team.issues.closed.where(:archived_at => nil).update_all :archived_at => Time.now.beginning_of_minute

    AuditEntry.create do |entry|
      entry.user   = current_user
      entry.team   = team
      entry.action = :archive_issues
    end

    head :ok
  end
end
