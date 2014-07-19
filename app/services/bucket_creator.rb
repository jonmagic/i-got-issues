class BucketCreator

  # See ServiceBase for the Public interface to this service.
  include ServiceBase

  # Team concerns for this service.
  include ServiceTeams

  # Auditing concern.
  include ServiceAudit

  # Internal: Create bucket only after ensuring the actor has permission.
  #
  # Raises NotAuthorized or returns a Bucket instance.
  def process
    authorize_write_team!

    Bucket.create do |bucket|
      bucket.name               = params[:bucket][:name]
      bucket.row_order_position = :last
      bucket.team_id            = team_id
    end.tap {|bucket| log(actor, bucket, params) }
  end
end
