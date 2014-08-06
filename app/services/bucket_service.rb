class BucketService < ApplicationService

  # Public: Finds Bucket by id and sets on BucketService.
  #
  # bucket_id - An Integer representing the Bucket id in the database.
  #
  # Returns a BucketService.
  def for_bucket_by_id(bucket_id)
    self.bucket = team.buckets.find(bucket_id)
    self
  end

  # Public: The Bucket this BucketService is operating on.
  #
  # Returns a NilClass or Bucket.
  attr_accessor :bucket

  # Public: Create Bucket for Team from params.
  #
  # params - A Hash of attributes (name, ...) to instantiate Bucket with.
  #
  # Returns a Bucket.
  def create_bucket_with_params(params)
    bucket = Bucket.new(params)
    bucket.team_id = team.id
    bucket.row_order_position = :last
    bucket.save
    self.bucket = bucket
    log(:create_bucket)
    bucket
  end

  # Public: Update the Bucket with the params.
  #
  # params - A Hash of attributes (name, ...) to update the Bucket with.
  #
  # Returns a Bucket.
  def update_bucket_with_params(params)
    if params[:name].present?
      rename_bucket(params[:name])
    elsif params[:row_order_position].present?
      move_bucket(params[:row_order_position])
    end

    bucket
  end

  # Public: Renames the Bucket.
  #
  # name - String
  #
  # Returns a Bucket.
  def rename_bucket(name)
    log(:rename_bucket) do
      bucket.update(:name => name)
    end

    bucket
  end

  # Public: Moves Bucket to new position.
  #
  # position - Integer representing index of bucket in array
  #
  # Returns a Bucket.
  def move_bucket(position)
    log(:move_bucket) do
      bucket.update(:row_order_position => position)
    end

    bucket
  end

  # Public: Move issues out of the Bucket being removed and to a destination
  # Bucket if one is available and then remove the source Bucket.
  #
  # Returns a Bucket.
  def move_issues_and_remove_bucket
    log(:remove_bucket) do
      bucket.issues.each {|issue| issue.move_to_bucket(target_bucket) }
      bucket.destroy
    end

    bucket
  end

private

  def target_bucket
    @target_bucket ||= team.buckets.where.not(:id => bucket.id).last
  end

  def log(action)
    AuditEntry.create do |entry|
      entry.user                 = user
      entry.team                 = team
      entry.action               = action
      entry.bucket_before_action = bucket

      yield if block_given?

      if action == :remove_bucket
        entry.bucket_after_action = target_bucket
      else
        entry.bucket_after_action = bucket
      end
    end
  end
end
