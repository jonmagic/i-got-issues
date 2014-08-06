class Bucket < ActiveRecord::Base
  include RankedModel

  # Public: Bucket name.
  # column :name
  # Returns a String.
  validates :name, :presence => true

  # Public: Has many issues.
  has_many :issues, :class_name => "PrioritizedIssue"

  # Public: Position of bucket.
  # column :row_order
  # Returns an Integer.
  validates :row_order, :presence => true
  ranks :row_order, :with_same => :team_id

  # Public: Change position of Bucket.
  #
  # position - Integer or symbol (:first, :last, :up, :down).
  def change_position(position)
    update_attribute :row_order_position, position
  end

  # Public: Get the current column position of the bucket. Columns start at 1
  # and go up.
  #
  # Returns an Integer >= 1.
  def current_position
    team.buckets.pluck(:row_order).index(row_order) + 1
  end

  # Public: Id of team on GitHub.
  # column :team_id
  # Returns an Integer.
  validates :team_id, :presence => true

  # Public: Team this bucket belongs to.
  #
  # Returns a Team.
  def team
    Team.new(:id => team_id)
  end

  # column :created_at
  # column :updated_at

  # Buckets by team id.
  scope :by_team_id, -> (team_id) { where(:team_id => team_id).rank(:row_order) }
end
