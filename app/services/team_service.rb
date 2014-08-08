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

  def user_teams
    @user_teams ||= user_teams_api_request.map {|t| Team.new(t) }
  end

private

  EXPIRES_IN = 60.seconds

  def initialize(user)
    @user = user
  end

  attr_reader :user

  attr_reader :team_id

  def github_client
    user.github_client
  end

  def team_attributes_from_github_team_response(github_team)
    {
      :id           => github_team[:id],
      :name         => github_team[:name],
      :organization => github_team[:organization][:login],
      :avatar_url   => github_team[:organization][:avatar_url]
    }
  end

  def team_api_request
    Rails.cache.fetch("user-#{user.id}.team-#{team_id}", :expires_in => EXPIRES_IN) do
      github_team = github_client.team(team_id)
      team_attributes_from_github_team_response(github_team)
    end
  end

  def user_teams_api_request
    Rails.cache.fetch("user-#{user.id}.teams", :expires_in => EXPIRES_IN) do
      github_client.user_teams.map do |github_team|
        team_attributes_from_github_team_response(github_team)
      end
    end
  end

  def team_members
    @team_members ||= begin
      team_members_api_request.map {|attributes| TeamMember.new(attributes) }
    end
  end

  def team_members_api_request
    Rails.cache.fetch("user-#{user.id}.team-#{team_id}.members", :expires_in => EXPIRES_IN) do
      github_client.team_members(team_id).map do |github_user|
        {
          :login => github_user[:login]
        }
      end
    end
  end
end
