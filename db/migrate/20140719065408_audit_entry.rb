class AuditEntry < ActiveRecord::Migration
  def change
    create_table :audit_entries do |t|
      t.integer  :actor_id,          :null => false
      t.string   :actor_login
      t.string   :actor_email
      t.string   :service_class,     :null => false
      t.string   :target_class,      :null => false
      t.integer  :target_id,         :null => false
      t.json     :target_attributes
      t.json     :target_changes
      t.json     :controller_params
      t.datetime :created_at
    end
  end
end
