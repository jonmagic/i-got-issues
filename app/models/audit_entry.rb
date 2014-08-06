class AuditEntry < ActiveRecord::Base

  # Public: Team entry belongs to.
  # column :team_id
  validates :team_id, :presence => true
  # Returns a Team.
  def team
    Team.new(:id => team_id)
  end

  # Public: Team name when entry was created.
  # column :team_name
  # Returns a String.

  # Public: Set team attributes on entry.
  def team=(team)
    self.team_id   = team.id
    self.team_name = team.name
  end

  # Public: User that took the action.
  # column :user_id
  # Returns a User.
  belongs_to :user
  validates :user_id, :presence => true

  # Public: User login when the entry was created.
  # column :user_login
  # Returns a String.

  # Public: Set the user attributes on entry.
  def user=(user)
    self.user_id    = user.id
    self.user_login = user.login
  end

  # Public: Action the user took.
  # column :action
  # Returns a Symbol.
  def action
    super.to_sym
  end

  # Internal: Action enumerator.
  enum :action => [
    :import_issue,
    :prioritize_issue,
    :remove_issue,
    :create_bucket,
    :rename_bucket,
    :move_bucket,
    :remove_bucket,
    :archive_issues,
  ]

  # Public: The associated Issue.
  # column :issue_id
  # Returns an Issue.
  belongs_to :issue

  # Public: The issue title when the entry was created.
  # column :issue_title
  # Returns a String.

  # Public: The associated PrioritizedIssue.
  # column :prioritized_issue_id
  # Returns a PrioritizedIssue.
  belongs_to :prioritized_issue

  # Public: The starting position of the issue (lower is higher priority).
  # column :issue_start_position
  # Returns an Integer.

  # Public: The ending position of the issue (lower is higher priority).
  # column :issue_end_position
  # Returns an Integer.

  # Public: The associated Bucket before action was taken.
  # column :source_bucket_id
  # Returns a Bucket.
  belongs_to :source_bucket, :class_name => "Bucket"

  # Public: The associated Bucket name before action was taken.
  # column :source_bucket_name
  # Returns a String.

  # Public: The associated Bucket after action was taken.
  # column :target_bucket_id
  # Returns a Bucket.
  belongs_to :target_bucket, :class_name => "Bucket"

  # Public: The associated Bucket name after action was taken.
  # column :target_bucket_name
  # Returns a String.

  # Public: Set issue related attributes before action.
  def issue_before_action=(prioritized_issue)
    self.issue_id             = prioritized_issue.issue.id
    self.issue_title          = prioritized_issue.issue.title
    self.prioritized_issue_id = prioritized_issue.id
    self.issue_start_position = prioritized_issue.current_position
    self.source_bucket_id     = prioritized_issue.bucket.id
    self.source_bucket_name   = prioritized_issue.bucket.name
  end

  # Public: Set issue related attributes after action.
  def issue_after_action=(prioritized_issue)
    return unless prioritized_issue.persisted?

    self.issue_end_position = prioritized_issue.current_position
    self.target_bucket_id   = prioritized_issue.bucket.id
    self.target_bucket_name = prioritized_issue.bucket.name
  end

  # Public: The position of the Bucket before action was taken.
  # column :bucket_start_position
  # Returns an Integer.

  # Public: The position of the Bucket after action was taken.
  # column :bucket_end_position
  # Returns an Integer.

  # Public: Set source bucket attributes before action.
  def bucket_before_action=(bucket)
    self.source_bucket_id      = bucket.id
    self.source_bucket_name    = bucket.name
    self.bucket_start_position = bucket.current_position
  end

  # Public: Set bucket related attributes after action.
  def bucket_after_action=(bucket)
    self.target_bucket_id    = bucket.id
    self.target_bucket_name  = bucket.name
    self.bucket_end_position = bucket.current_position
  end

  # Public: Timestamp from when entry was created.
  # column :created_at
  # Returns an ActiveSupport::TimeWithZone.

  # Last 100 audit log entries for a Team sorted oldest to newest.
  scope :by_team_id, -> (team_id) { where(:team_id => team_id).order(:created_at => :desc).limit(100) }
end
