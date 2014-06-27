class Team
  extend ActiveModel::Naming

  def initialize(params={})
    @id           = params[:id]
  end

  attr_reader :id

  def to_param
    id.to_s
  end

  def buckets
    Bucket.by_team_id(id)
  end

  def issues
    PrioritizedIssue.bucket(buckets)
  end
end
