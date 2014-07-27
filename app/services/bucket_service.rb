class BucketService
  def self.create(team, params)
    bucket = Bucket.new(params)
    bucket.team_id = team.id
    bucket.row_order_position = :last
    bucket.save
    bucket
  end

  def initialize(bucket_id)
    @bucket_id = bucket_id
  end

  attr_reader :bucket_id

  def bucket
    @bucket ||= Bucket.find(bucket_id)
  end

  def update(params)
    if params[:name].present?
      bucket.name = params[:name]
    end

    if params[:row_order_position]
      bucket.row_order_position = params[:row_order_position]
    end

    bucket.save
  end

  def destroy
    bucket.issues.each {|issue| issue.move_to_bucket(destination_bucket) }
    bucket.destroy
  end

private

  def team
    bucket.team
  end

  def destination_bucket
    @destination_bucket ||= team.buckets.where.not(:id => bucket.id).last
  end
end
