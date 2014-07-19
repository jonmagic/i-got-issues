class BucketUpdater

  # See ServiceBase for the Public interface to this service.
  include ServiceBase

  # Team concerns for this service.
  include ServiceTeams

  # Internal: Update bucket only after ensuring user has permission.
  #
  # Raises NotAuthorized or returns a Bucket instance.
  def process
    authorize_write_team!

    bucket = Bucket.find params[:id]
    bucket.name               = name if name
    bucket.row_order_position = position if position
    bucket.team_id            = team_id if team_id
    bucket.save
    bucket
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
