class BucketCreator

  # See ServiceBase for the Public interface to this service.
  include ServiceBase

  # Internal: Create bucket only after ensuring user has permission.
  #
  # Raises NotAuthorized or returns a Bucket instance.
  def process
    authorize_write_team!

    Bucket.create do |bucket|
      bucket.name               = params[:bucket][:name]
      bucket.row_order_position = :last
      bucket.team_id            = team_id
    end
  end
end
