class TeamService
  def self.for_user(user)
    new(user)
  end

  def for_team_by_id(team_id)
    @team_id = team_id
    self
  end

  def team
    @team ||= begin
      team = Team.new(team_api_request)
      team.members = team_members
      team
    end
  end

private

  def initialize(user)
    @user = user
  end

  attr_reader :user

  attr_reader :team_id

  def github_client
    user.github_client
  end

  def team_api_request
    github_client.team(team_id)
  end

  def team_members
    @team_members ||= begin
      team_members_api_request.map {|attributes| TeamMember.new(attributes) }
    end
  end

  def team_members_api_request
    github_client.team_members(team_id)
  end
end
