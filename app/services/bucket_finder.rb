class BucketFinder

  # See ServiceBase for the Public interface to this service.
  include ServiceBase

  # Internal: Find bucket for team after ensuring user has permission.
  #
  # Returns a Bucket instance or raises NotAuthorized.
  def process
    authorize_read_team!

    team.buckets.find(bucket_id)
  end
end
