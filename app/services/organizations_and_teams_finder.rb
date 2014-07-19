class OrganizationsAndTeamsFinder

  # See ServiceBase for the Public interface to this service.
  include ServiceBase

  # Internal: Find teams and group by organization and then sort organizations
  # alphabetically.
  #
  # Returns a Hash of Team instances by organization.
  def process
    teams_by_organization.sort
  end

  # Internal: Find teams for user and group by organization.
  #
  # Returns a Hash of Team instances by organization.
  def teams_by_organization
    user_teams.group_by {|team| team.organization.downcase }
  end
end
