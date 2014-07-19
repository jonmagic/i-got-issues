module ServiceTeams
  # Internal: Authorize that user has write permissions for this team.
  #
  # Returns NilClass or raises NotAuthorized.
  def authorize_write_team!
    unless team_members.detect {|team_member| team_member.login == user.login }
      raise NotAuthorized
    end
  end

  # Internal: Get team members for this team.
  #
  # Returns an Array of TeamMember instances.
  def team_members
    user.github_client.team_members(params[:team_id]).map {|team_params| TeamMember.new(team_params) }
  end

  # Internal: The id for this team.
  #
  # Returns an Integer.
  def team_id
    params[:team_id]
  end
end
