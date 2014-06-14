class IssueImporter
  def initialize(github_client)
    @github_client = github_client
  end

  def from_url(url)
    parsed_url  = UrlParser.new url
    @owner      = parsed_url.owner
    @repository = parsed_url.repository
    @number     = parsed_url.number

    import
  end

  def from_issue(issue)
    @owner      = issue.owner
    @repository = issue.repository
    @number     = issue.number

    import
  end

private
  def github_issue
    @github_issue ||= @github_client.issue "#{@owner}/#{@repository}", @number
  end

  def import
    issue = Issue.by_owner_repo_number(@owner, @repository, @number).first_or_initialize

    issue.update_attributes \
      :title      => github_issue["title"],
      :state      => github_issue["state"],
      :assignee   => github_issue["assignee"] ? github_issue["assignee"]["login"] : nil,
      :labels     => github_issue["labels"].map {|label| label[:name] }
  end
end
