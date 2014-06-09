class IssueSync
  def initialize(github_client)
    @github_client = github_client
    @url           = nil
    @issue         = nil
  end

  attr_reader   :github_client
  attr_accessor :number, :owner, :repository, :url
  attr_writer   :issue

  def from_url(url)
    self.url        = url
    self.owner      = parsed_url.owner
    self.repository = parsed_url.repository
    self.number     = parsed_url.number

    sync
  end

  def from_issue(issue)
    self.issue      = issue
    self.owner      = issue.owner
    self.repository = issue.repository
    self.number     = issue.number

    sync
  end

  def sync
    if newer? && changed?
      update_github
    elsif changed?
      update_local
    end

    issue.update_attribute :synced_at, Time.zone.now

    issue
  end

  def newer?
    return false if issue.new_record?
    return false if issue.synced_at.blank?
    return false if github_issue[:updated_at] > issue.synced_at
    true
  end

  def changed?
    github_attributes != local_attributes
  end

  def set_issue=(issue)
    self.issue      = issue
    self.owner      = issue.owner
    self.repository = issue.repository
    self.number     = issue.number
  end

  def github_attributes
    @github_attributes ||= {
      :title      => github_issue["title"],
      :state      => github_issue["state"],
      :assignee   => github_issue["assignee"] ? github_issue["assignee"]["login"] : nil,
      :labels     => github_issue["labels"].map {|label| label[:name] }
    }
  end

  def local_attributes
    {
      :title    => issue.title,
      :state    => issue.state,
      :assignee => issue.assignee,
      :labels   => issue.labels
    }
  end

private

  def github_issue
    @github_issue ||= github_client.issue "#{owner}/#{repository}", number
  end

  def update_local
    issue.update_attributes(github_attributes)
  end

  def update_github
    github_client.update_issue \
      "#{owner}/#{repository}", number, github_attributes[:title], github_attributes[:body],
      :state => issue.state, :assignee => issue.assignee
  end

  def issue
    return @issue if @issue.present?

    self.set_issue = Issue.where(
      :owner      => owner,
      :repository => repository,
      :number     => number
    ).first_or_initialize
  end

  def parsed_url
    @parsed_url ||= UrlParser.new url
  end
end
