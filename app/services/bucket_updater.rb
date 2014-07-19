class BucketUpdater

  # See ServiceBase for the Public interface to this service.
  include ServiceBase

  # Internal: Update bucket only after ensuring the actor has permission.
  #
  # Raises NotAuthorized or returns a Bucket instance.
  def process
    authorize_write_team!

    bucket.name               = name     if name
    bucket.row_order_position = position if position
    bucket.team_id            = team_id  if team_id
    bucket.save
    bucket
  end

  # Internal: The Bucket that will be updated.
  #
  # Returns a Bucket.
  def bucket
    @bucket ||= Bucket.find(params[:id])
  end

  # Internal: Bucket name from params.
  #
  # Returns a String.
  def name
    params[:bucket][:name]
  end

  # Internal: Bucket position in relation to other buckets.
  #
  # Returns an Integer.
  def position
    params[:bucket][:row_order_position]
  end
end
