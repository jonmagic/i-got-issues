class BucketDestroyer

  # See ServiceBase for the Public interface to this service.
  include ServiceBase

  # Internal: Destroy bucket only after ensuring user has permission.
  #
  # Raises NotAuthorized or returns a Bucket instance.
  def process
    authorize_write_team!

    # TODO: test that issues get moved to new bucket
    bucket.issues.each {|issue| issue.move_to_bucket(destination_bucket) }
    bucket.destroy
    bucket
  end

  # Internal: The Bucket that will be destroyed.
  #
  # Returns a Bucket.
  def bucket
    @bucket ||= Bucket.find(params[:id])
  end

  # Internal: The Team the bucket belongs to.
  #
  # Returns a Team.
  def team
    bucket.team
  end

  # Internal: The Bucket that issues will be moved to.
  #
  # Returns a Bucket or NilClass.
  def destination_bucket
    @destination_bucket ||= team.buckets.where.not(:id => bucket.id).last
  end
end
