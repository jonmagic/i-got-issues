class AddPullRequestToIssue < ActiveRecord::Migration
  def change
    add_column :issues, :pull_request, :boolean, :default => false
  end
end
