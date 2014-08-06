class CreateAuditEntries < ActiveRecord::Migration
  def change
    create_table :audit_entries do |t|
      t.integer  :team_id, :null => false
      t.string   :team_name
      t.integer  :user_id, :null => false
      t.string   :user_login
      t.integer  :action
      t.integer  :issue_id
      t.string   :issue_title
      t.integer  :prioritized_issue_id
      t.integer  :issue_start_position
      t.integer  :issue_end_position
      t.integer  :source_bucket_id
      t.string   :source_bucket_name
      t.integer  :target_bucket_id
      t.string   :target_bucket_name
      t.integer  :bucket_start_position
      t.integer  :bucket_end_position
      t.datetime :created_at
    end

    add_index :audit_entries, [:created_at, :team_id]
  end
end
