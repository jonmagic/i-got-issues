class BucketsFinder

  # See ServiceBase for the Public interface to this service.
  include ServiceBase

  # Internal: Find buckets for team after ensuring user has permission.
  #
  # Returns an Array of Bucket instances or raises NotAuthorized.
  def process
    authorize_read_team!

    team.buckets
  end
end
