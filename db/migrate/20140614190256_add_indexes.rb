class AddIndexes < ActiveRecord::Migration
  def change
    add_index :buckets,            [:team_id, :row_order]
    add_index :issues,             [:owner, :repository, :number], :unique => true
    add_index :prioritized_issues, [:bucket_id, :issue_id], :unique => true
    add_index :prioritized_issues, [:bucket_id, :row_order]
    add_index :services,           [:provider, :uid], :unique => true
    add_index :users,              [:login], :unique => true
  end
end
