class TeamMember
  def initialize(params)
    @login = params[:login]
  end

  attr_reader :login
end
