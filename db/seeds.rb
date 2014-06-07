# Create user
User.create(:name => "jonmagic", :email => "jonmagic@gmail.com")

# Create buckets
icebox  = Bucket.create(:name => "Icebox",  :row_order => 2)
backlog = Bucket.create(:name => "Backlog", :row_order => 1)
current = Bucket.create(:name => "Current", :row_order => 0)

# Create prioritized issues
(99..117).each do |n|
  github_issue = Octokit.issue "bkeepers/dotenv", n

  prioritized_issue = PrioritizedIssue.new :bucket => backlog
  prioritized_issue.issue = Issue.create \
    :title             => github_issue["title"],
    :github_owner      => "bkeepers",
    :github_repository => "dotenv",
    :github_id         => n,
    :state             => github_issue["state"]
  prioritized_issue.save
end
