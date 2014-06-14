class Team
  def initialize(id)
    @id = id
  end

  attr_reader :id

  def to_param
    id.to_s
  end

  def buckets
    Bucket.by_team_id(id)
  end
end
