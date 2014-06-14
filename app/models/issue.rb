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

  # Public: Set assignee.
  #
  # assignee - String users GitHub login.
  def assignee=(assignee)
    write_attribute :assignee, assignee.present? ? assignee : nil
  end

  # Public: Find issue by owner, repository, and number.
  scope :by_owner_repo_number, -> (owner, repository, number) {
    where(:owner => owner, :repository => repository, :number => number)
  }
end
