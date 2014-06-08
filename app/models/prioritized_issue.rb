class PrioritizedIssue < ActiveRecord::Base
  include RankedModel

  # Public: Associated Issue.
  # column :issue_id
  validates :issue_id,  :presence => true
  belongs_to :issue

  # Public: Associated Bucket.
  # column :bucket_id
  validates :bucket_id, :presence => true
  belongs_to :bucket

  scope :bucket, ->(bucket) { where(:bucket => bucket).rank(:row_order) }

  # Public: Priority of issue in bucket.
  # column :row_order
  validates :row_order, :presence => true
  ranks :row_order, :with_same => :bucket_id

  # Public: Change position of prioritized issue, the bigger the number the lower
  # the priority (from a UI standpoint).
  #
  # position - Integer or symbol (:first, :last, :up, :down).
  def change_position(position)
    update_attribute :row_order_position, position
  end

  # Public: Move to bucket. Optionally position issue in bucket.
  #
  # bucket - Bucket instance.
  # position - Integer or symbol (:first, :last, :up, :down).
  def move_to_bucket(bucket, position = :last)
    update_attributes :bucket => bucket, :row_order_position => position
  end

  # Public: Delegate issue methods to associated Issue.
  delegate :title, :github_owner, :github_repository,:github_id, :state,
    :created_at, :updated_at, :open?, :closed?, :assignee, :to => :issue

  # column :created_at
  # column :updated_at
end
