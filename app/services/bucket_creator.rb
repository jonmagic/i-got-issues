class BucketCreator

  # See ServiceBase for the Public interface to this service.
  include ServiceBase

  # Internal: Create bucket only after ensuring user has permission.
  #
  # Returns a Bucket instance or raises NotAuthorized.
  def process
    authorize_write_team!

    Bucket.create do |bucket|
      bucket.name               = params[:bucket][:name]
      bucket.row_order_position = :last
      bucket.team_id            = team_id
    end
  end
end
