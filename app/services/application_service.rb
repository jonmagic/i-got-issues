# Services should inherit from ApplicationService in order to take advantage
# of .for_user_and_team instantiation.
class ApplicationService

  # Public: Create instance of ApplicationService for a User and a Team.
  #
  # user - User instance
  # team - Team instance
  #
  # Returns an ApplicationService or subclass instance.
  def self.for_user_and_team(user, team)
    new(user, team)
  end

  def initialize(user, team)
    @user = user
    @team = team
  end

  # Internal: The User this service will be acting for.
  #
  # Returns a User.
  attr_reader :user

  # Internal: The Team this service will be acting on.
  #
  # Returns a Team.
  attr_reader :team

  # Internal: The github client that the service will use to interact with
  # the GitHub API.
  #
  # Returns an Octokit::Client instance.
  def github_client
    @github_client ||= user.github_client
  end
end
