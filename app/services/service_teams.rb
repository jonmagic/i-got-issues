module ServiceTeams
  # Internal: Raise exception if actor does not have write permission for team.
  #
  # Returns NilClass or raises NotAuthorized.
  def authorize_write_team!
    unless team_members.detect {|team_member| team_member.login == actor.login }
      raise NotAuthorized
    end
  end

  # Internal: The id for this team.
  #
  # Returns an Integer.
  def team_id
    params[:team_id]
  end

  # Internal: Get team members for this team.
  #
  # Returns an Array of TeamMember instances.
  def team_members
    github_client.team_members(team_id).map {|team_params| TeamMember.new(team_params) }
  end
end
