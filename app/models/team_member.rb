class TeamMember
  def initialize(params)
    @login = params[:login]
  end

  attr_reader :login

  def to_hash
    {
      :login => login
    }
  end
end
