class PrioritizedIssueArchiver

  # See ServiceBase for the Public interface to this service.
  include ServiceBase

  # Internal: Create bucket only after ensuring user has permission.
  #
  # Returns a TrueClass or raises NotAuthorized.
  def process
    authorize_write_team!

    issues.update_all :archived_at => Time.now.beginning_of_minute
    true
  end

  # Internal: Closed but not yet archived issues for team.
  #
  # Returns an Array of PrioritizedIssues.
  def issues
    team.issues.closed.where(:archived_at => nil)
  end
end
