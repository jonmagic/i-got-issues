class BucketService
  # Public: Create Bucket for Team from params.
  #
  # team   - The Team instance the Bucket should be associated with.
  # params - A Hash of attributes (name, ...) to instantiate Bucket with.
  #
  # Returns a Bucket.
  def self.create_for_team_with_params(team, params)
    bucket = Bucket.new(params)
    bucket.team_id = team.id
    bucket.row_order_position = :last
    bucket.save
    bucket
  end

  # Public: Create BucketService instance for a Bucket by the bucket id and
  # team the bucket should belong to.
  #
  # team      - The Team instance the Bucket should be associated with.
  # bucket_id - An Integer representing the Bucket id in the database.
  #
  # Returns a BucketService.
  def self.for_bucket_by_team_and_bucket_id(team, bucket_id)
    new(team, bucket_id)
  end

  # Public: Update the Bucket with the params.
  #
  # params - A Hash of attributes (name, ...) to update the Bucket with.
  #
  # Returns a TrueClass or FalseClass.
  def update_bucket_with_params(params)
    if params[:name].present?
      bucket.name = params[:name]
    end

    if params[:row_order_position]
      bucket.row_order_position = params[:row_order_position]
    end

    bucket.save
  end

  # Public: Move issues out of the Bucket being destroyed and to a destination
  # Bucket if one is available and then destroy the source Bucket.
  def move_issues_and_destroy_bucket
    destination_bucket = team.buckets.where.not(:id => bucket.id).last
    bucket.issues.each {|issue| issue.move_to_bucket(destination_bucket) }
    bucket.destroy
  end

  # Public: The Bucket this BucketService is operating on.
  #
  # Returns a Bucket.
  def bucket
    @bucket ||= team.buckets.find(bucket_id)
  end

private

  def initialize(team, bucket_id)
    @bucket_id = bucket_id
    @team      = team
  end

  # Private: Bucket id in the database.
  #
  # Returns an Integer.
  attr_reader :bucket_id

  # Private: The Team the Bucket is associated with.
  #
  # Returns a Team.
  attr_reader :team

end
