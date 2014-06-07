class CreatePrioritizedIssues < ActiveRecord::Migration
  def change
    create_table :prioritized_issues do |t|
      t.integer :issue_id,  :null => false
      t.integer :bucket_id, :null => false
      t.integer :row_order, :null => false, :default => 0

      t.timestamps
    end
  end
end
