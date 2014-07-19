module ServiceBase
  module ClassMethods

    # Public: This is the public interface for a service and takes a User and a
    # params Hash. Can be overwritten in specific services if needed.
    #
    # user   - User instance.
    # params - Hash of params.
    #
    # See service #process for return definition.
    def process(user, params)
      new(user, params).process
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  # Internal: User passed in at initialization.
  attr_reader :user

  # Internal: Params Hash passed in at initialization.
  attr_reader :params

  def initialize(user, params)
    @user = user
    @params = params
  end

  # Internal: GitHub client for user.
  #
  # Returns an Octokit::Client.
  def github_client
    user.github_client
  end

  # Internal: Raise exception if actor does not have write permission for team.
  #
  # Returns NilClass or raises NotAuthorized.
  def authorize_write_team!
    unless team_members.detect {|team_member| team_member.login == user.login }
      raise NotAuthorized
    end
  end

  # Internal: The id for this team.
  #
  # Returns an Integer.
  def team_id
    params[:team_id]
  end

  # Internal: The Team the bucket belongs to.
  #
  # Returns a Team.
  def team
    @team ||= Team.new(:id => team_id)
  end

  # Internal: Get team members for this team.
  #
  # Returns an Array of TeamMember instances.
  def team_members
    github_client.team_members(team_id).map {|team_params| TeamMember.new(team_params) }
  end
end
