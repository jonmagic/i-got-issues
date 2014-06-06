class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string   :title,             :null => false
      t.string   :github_owner,      :null => false
      t.string   :github_repository, :null => false
      t.integer  :github_id,         :null => false
      t.integer  :state,             :null => false

      t.timestamps
    end
  end
end
