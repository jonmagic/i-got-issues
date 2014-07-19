class PrioritizedIssueArchiver

  # See ServiceBase for the Public interface to this service.
  include ServiceBase

  # Team concerns for this service.
  include ServiceTeams

  # Internal: Create bucket only after ensuring the actor has permission.
  #
  # Raises NotAuthorized or returns a Bucket instance.
  def process
    authorize_write_team!

    issues.update_all :archived_at => Time.now.beginning_of_minute
  end

  # Internal: The Team the bucket belongs to.
  #
  # Returns a Team.
  def team
    @team ||= Team.new(:id => team_id)
  end

  # Internal: Closed but not yet archived issues for team.
  #
  # Returns an Array of PrioritizedIssues.
  def issues
    team.issues.closed.where(:archived_at => nil)
  end
end
