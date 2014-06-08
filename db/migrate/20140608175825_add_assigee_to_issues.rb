class AddAssigeeToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :assignee, :string
  end
end
