class AddArchivedAtToPrioritizedIssue < ActiveRecord::Migration
  def change
    add_column :prioritized_issues, :archived_at, :datetime
  end
end
