class User < ActiveRecord::Base

  # Public: GitHub login.
  # column :login
  # Returns a String.
  validates :login, :uniqueness => true

  # Public: Primary email address on GitHub.
  # column :email
  # Returns a String.

  # Public: Id of team on GitHub.
  # column :team_id
  # Returns an Integer.

  has_many :buckets, -> { rank(:row_order) },
    :primary_key => "team_id",
    :foreign_key => "team_id"

  # column :created_at
  # column :updated_at

  has_many :services

  attr_accessor :github_client
end
