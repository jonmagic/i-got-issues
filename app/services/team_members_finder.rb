class TeamMembersFinder

  # See ServiceBase for the Public interface to this service.
  include ServiceBase

  # Internal: Find TeamMembers only after ensuring user has permission.
  #
  # Returns an Array of TeamMember instances or raises NotAuthorized.
  def process
    authorize_read_team!

    team_members
  end
end
