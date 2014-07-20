class Team
  extend ActiveModel::Naming

  def initialize(params={})
    @id           = params[:id]
    @name         = params[:name]
    @organization = params[:organization] ? params[:organization][:login] : nil
    @avatar_url   = params[:organization] ? params[:organization][:avatar_url] : nil
    @members      = params.fetch(:members) { [] }
  end

  attr_accessor :id, :name, :organization, :avatar_url, :members

  def to_param
    id.to_s
  end

  def buckets
    Bucket.by_team_id(id)
  end

  def issues
    PrioritizedIssue.bucket(buckets)
  end

  def ship_lists
    PrioritizedIssue.archives(buckets).map {|timestamp| ShipList.new(:timestamp => timestamp) }
  end

  def ship_list(timestamp)
    issues = PrioritizedIssue.archive(buckets, timestamp.to_time)
    ShipList.new(:timestamp => timestamp, :issues => issues)
  end

  def member?(user)
    !!members.detect {|member| user.login == member.login }
  end
end
