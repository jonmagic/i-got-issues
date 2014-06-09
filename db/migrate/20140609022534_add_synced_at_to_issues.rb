class AddSyncedAtToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :synced_at, :datetime
  end
end
