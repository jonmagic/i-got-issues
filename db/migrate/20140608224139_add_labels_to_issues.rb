class AddLabelsToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :labels, :binary
  end
end
