class TeamFinder

  # See ServiceBase for the Public interface to this service.
  include ServiceBase

  # Internal: Find Team only after ensuring user has permission.
  #
  # Returns a Team instance or raises NotAuthorized.
  def process
    authorize_read_team!

    team
  end
end
