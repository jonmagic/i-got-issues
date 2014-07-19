class BucketCreator
  # Public: Create a Bucket after ensuring user has access to the team.
  #
  # user   - User instance.
  # params - Hash of Bucket params.
  #
  # Returns Bucket instance.
  def self.process(user, params)
    new(user, params).create_bucket
  end

  # Internal: Everything below.

  def initialize(user, params)
    @user = user
    @params = params
  end

  attr_reader :user, :params

  def create_bucket
    authorize_write_team!

    Bucket.create do |bucket|
      bucket.name               = params[:bucket][:name]
      bucket.row_order_position = :last
      bucket.team_id            = team_id
    end
  end

  def authorize_write_team!
    unless team_members.detect {|team_member| team_member.login == user.login }
      raise NotAuthorized
    end
  end

  EXPIRES_IN = 5.minutes

  def team_members
    user.github_client.team_members(params[:team_id]).map {|team_params| TeamMember.new(team_params) }
  end

  def team_id
    params[:team_id]
  end
end
