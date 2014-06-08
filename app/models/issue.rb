class Issue < ActiveRecord::Base
  # Public: Issue title.
  # column :title
  # Returns a String.

  # Public: Login for GitHub issue owner.
  # column :owner
  # Returns a String.

  # Public: GitHub repository name issue belongs to.
  # column :repository
  # Returns a String.

  # Public: Issue number for repository on GitHub.
  # column :number
  # Returns an Integer.

  # Public: Issue state.
  # column :state
  # Returns a String.
  enum :state => [:open, :closed]

  # Public: Has many prioritized issues.
  has_many :prioritized_issues, :dependent => :destroy

  # Public: Login of assignee.
  # column :assignee
  # Returns a String.

  # Public: Labels for issue.
  # column :labels
  serialize :labels, Array

  # column :created_at
  # column :updated_at

  def self.from_attributes(attributes)
    issue = where(
      :owner      => attributes[:owner],
      :repository => attributes[:repository],
      :number     => attributes[:number]
    ).first_or_initialize

    issue.update_attributes(attributes)
    issue
  end
end
