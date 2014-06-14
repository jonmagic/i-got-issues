class Team
  def initialize(id)
    @id = id
  end

  attr_reader :id

  def to_param
    id.to_s
  end
end
