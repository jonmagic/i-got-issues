class IssueImporter
  # Public: Import issue from GitHub by it's url.
  #
  # url - String url for GitHub issue.
  #       Example: https://github.com/jonmagic/scriptular/issues/1
  #
  # Returns an Issue.
  def from_url(url)
    parsed_url  = IssueUrlParser.new(url)
    @owner      = parsed_url.owner
    @repository = parsed_url.repository
    @number     = parsed_url.number

    import
  end

  # Public: Update local Issue with attributes from issue on GitHub.
  #
  # issue - Issue instance
  #
  # Returns an Issue.
  def from_issue(issue)
    @owner      = issue.owner
    @repository = issue.repository
    @number     = issue.number

    import
  end

  # Public: Import issue from GitHub API issue object.
  #
  # github_issue - Sawyer::Resource (hash) of issue attributes
  #
  # Returns an Issue.
  def from_github_issue(github_issue)
    parsed_url    = IssueUrlParser.new(github_issue["html_url"])
    @owner        = parsed_url.owner
    @repository   = parsed_url.repository
    @number       = parsed_url.number
    @github_issue = github_issue

    import
  end

private

  def initialize(github_client)
    @github_client = github_client
  end

  # Internal: GitHub API client instance.
  #
  # Returns an Octokit::Client.
  attr_reader :github_client

  # Internal: GitHub API issue Hash object.
  #
  # Returns a Sawyer::Resource.
  def github_issue
    @github_issue ||= github_client.issue "#{owner}/#{repository}", number
  end

  # Internal: Repository owner on GitHub.
  #
  # Returns a String.
  attr_reader :owner

  # Internal: Repository name on GitHub.
  #
  # Returns a String.
  attr_reader :repository

  # Internal: Issue number on GitHub.
  #
  # Returns an Integer.
  attr_reader :number

  # Internal: Import issue from GitHub, creating or updating local Issue.
  #
  # Returns an Issue.
  def import
    issue = Issue.by_owner_repo_number(owner, repository, number).first_or_initialize

    issue.update_attributes \
      :title      => github_issue["title"],
      :state      => github_issue["state"],
      :assignee   => github_issue["assignee"] ? github_issue["assignee"]["login"] : nil,
      :labels     => github_issue["labels"].map {|label| label[:name] }

    issue
  end
end
