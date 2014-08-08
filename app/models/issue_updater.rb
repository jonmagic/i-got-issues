class IssueUpdater
  def initialize(github_client)
    @github_client = github_client
  end

  attr_reader :github_client

  def from_issue(issue)
    github_issue = github_client.issue "#{issue.owner}/#{issue.repository}", issue.number

    github_client.update_issue \
      "#{issue.owner}/#{issue.repository}", issue.number,
      github_issue[:title], github_issue[:body],
      :state => issue.state, :assignee => issue.assignee
  end
end
