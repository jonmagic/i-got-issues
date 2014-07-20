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

  # Public: Finds non-archived PrioritizedIssues for `bucket`.
  scope :bucket, ->(bucket) { where(:bucket => bucket, :archived_at => nil).rank(:row_order) }

  # Public: Finds PrioritizedIssues whose associated isues are closed.
  scope :closed, -> { joins(:issue).where(["issues.state = ?", Issue.states["closed"]]) }

  # Public: Finds archived issues for bucket(s).
  scope :archived, ->(bucket) { where(:bucket => bucket).where.not(:archived_at => nil) }

  # Public: Finds distinct archived_at timestamps for bucket(s).
  scope :archives, ->(bucket) { archived(bucket).select(:archived_at).order(:archived_at => :desc).distinct.pluck(:archived_at) }

  # Public: Finds issues with same archived_at for bucket(s).
  scope :archive, ->(bucket, timestamp) { archived(bucket).where(:archived_at => timestamp) }

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
  delegate :title, :owner, :repository, :number, :state, :created_at,
    :updated_at, :open?, :closed?, :assignee, :labels, :to => :issue

  # column :created_at
  # column :updated_at

  # Public: Is the issue archived?
  #
  # Returns a TrueClass or FalseClass.
  def archived?
    archived_at?
  end
end
