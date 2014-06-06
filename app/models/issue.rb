class Issue < ActiveRecord::Base
  # Public: Issue title.
  # column :title
  # Returns a String.

  # Public: Username for GitHub issue owner.
  # column :github_owner
  # Returns a String.

  # Public: GitHub repository name issue belongs to.
  # column :github_repository
  # Returns a String.

  # Public: Issue id on GitHub.
  # column :github_id
  # Returns an Integer.

  # Public: Issue state.
  # column :state
  # Returns a String.
  enum :state => [:open, :closed]
  
  # column :created_at

  # column :updated_at
end
