class RenameFields < ActiveRecord::Migration
  def change
    rename_column :issues, :github_owner, :owner
    rename_column :issues, :github_repository, :repository
    rename_column :issues, :github_id, :number
    rename_column :users, :name, :login
  end
end
