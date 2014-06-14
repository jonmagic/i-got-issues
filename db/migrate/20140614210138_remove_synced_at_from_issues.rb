class RemoveSyncedAtFromIssues < ActiveRecord::Migration
  def change
    remove_column :issues, :synced_at
  end
end
