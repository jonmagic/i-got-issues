# Create user
User.create(:login => "jonmagic", :email => "jonmagic@gmail.com")

# Create buckets
icebox  = Bucket.create(:name => "Icebox",  :row_order => 2)
backlog = Bucket.create(:name => "Backlog", :row_order => 1)
current = Bucket.create(:name => "Current", :row_order => 0)

# Create prioritized issues
(99..117).each do |n|
  github_issue = Octokit.issue "bkeepers/dotenv", n
  issue = Issue.create \
    :title      => github_issue["title"],
    :owner      => "bkeepers",
    :repository => "dotenv",
    :number     => github_issue["number"],
    :state      => github_issue["state"],
    :assignee   => github_issue["assignee"] ? github_issue["assignee"]["login"] : nil,
    :labels     => github_issue["labels"].map {|label| label[:name] }

  issue.prioritized_issues.create :bucket => icebox
end
