class AddTeamIdToUsersAndBuckets < ActiveRecord::Migration
  def change
    add_column :users,   :team_id, :integer
    add_column :buckets, :team_id, :integer
  end
end
