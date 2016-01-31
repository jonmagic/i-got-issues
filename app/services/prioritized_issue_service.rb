class PrioritizedIssueService < ApplicationService

  # Public: Finds PrioritizedIssue by id and sets on PrioritizedIssueService.
  #
  # prioritized_issue_id - Integer id
  #
  # Returns a PrioritizedIssueService.
  def for_prioritized_issue_by_id(prioritized_issue_id)
    self.prioritized_issue = team.issues.find(prioritized_issue_id)
    self
  end

  # Public: PrioritizedIssue for PrioritizedIssueService. Normally set using
  # PrioritizedIssueService#for_prioritized_issue_by_id method.
  #
  # Returns a NilClass or PrioritizedIssue.
  attr_accessor :prioritized_issue

  # Public: Imports Issue and adds PrioritizedIssue to Team buckets.
  #
  # url - String, example: https://github.com/jonmagic/scriptular/issues/10
  #
  # Returns a PrioritizedIssue.
  def import_issue_from_url(url)
    if issue = issue_importer.from_url(url)
      create_or_update_prioritized_issue(issue)
    end
  end

  # Public: Import issues from a repository. Filter which issues to import by
  # passing in labels and state.
  #
  # url    - String url that can be parsed by RepositoryUrlParser
  # labels - String of comma seperated issue labels
  # state  - String issue state, "open" or "closed"
  #
  # Returns an Array of PrioritizedIssue instances.
  def import_issues_from_repository(url, labels=nil, state="open")
    url_parser = RepositoryUrlParser.new(url)
    options    = {:state => state}
    options[:labels] = labels if labels.present?

    github_issues = \
      github_client.
        issues "#{url_parser.owner}/#{url_parser.repository}", options

    github_issues.map do |github_issue|
      issue = issue_importer.from_github_issue(github_issue)
      create_or_update_prioritized_issue(issue)
    end
  end

  # Public: Updates Issue with params and then updates issue on GitHub.
  #
  # params - Hash of attributes (:state, :assignee, ...)
  #
  # Returns a PrioritizedIssue.
  def update_issue_with_params(params)
    Issue.transaction do
      prioritized_issue.issue.update(params)
      issue_updater.from_issue(prioritized_issue.issue)
    end
    self.prioritized_issue = prioritized_issue.reload
  end

  # Public: Removes a PrioritizedIssue from Team's buckets.
  #
  # Returns a PrioritizedIssue.
  def remove_prioritized_issue
    log(:remove_issue) do
      prioritized_issue.destroy
    end

    prioritized_issue
  end

  # Public: Moves PrioritizedIssue to a position in a Bucket.
  #
  # position - Integer representing new position
  # bucket   - Bucket instance
  #
  # Returns a PrioritizedIssue.
  def move_prioritized_issue_to_position_in_bucket(position, bucket)
    log(:prioritize_issue) do
      prioritized_issue.move_to_bucket(bucket, position)
    end

    prioritized_issue
  end

  # Public: Update Issue with values from GitHub.
  #
  # Returns a PrioritizedIssue.
  def update_issue_with_values_from_github
    issue_importer.from_issue(prioritized_issue.issue)
    self.prioritized_issue = prioritized_issue.reload
  end

  def issue_updated_at
    prioritized_issue.issue.updated_at
  end

private

  # Internal: IssueImporter for importing an issue from GitHub.
  #
  # Returns an IssueImporter.
  def issue_importer
    @issue_importer ||= IssueImporter.new(github_client)
  end

  # Internal: IssueUpdater for updating an issue on GitHub.
  #
  # Returns an IssueUpdater.
  def issue_updater
    @issue_updater ||= IssueUpdater.new(github_client)
  end

  def log(action)
    AuditEntry.create do |entry|
      entry.user                = user
      entry.team                = team
      entry.action              = action
      entry.issue_before_action = prioritized_issue

      yield if block_given?

      entry.issue_after_action  = prioritized_issue
    end
  end

  # Internal: Create or update PrioritizedIssue from it's associated Issue.
  #
  # issue - Issue instance
  #
  # Returns a PrioritizedIssue.
  def create_or_update_prioritized_issue(issue)
    prioritized_issue = PrioritizedIssue.where(
      :bucket => team.buckets,
      :issue  => issue
    ).first_or_initialize

    attributes = {:archived_at => nil}
    if prioritized_issue.new_record?
      attributes[:row_order_position] = :last
      attributes[:bucket] = team.buckets.last
    end

    prioritized_issue.update_attributes(attributes)
    self.prioritized_issue = prioritized_issue
    log(:import_issue)
    prioritized_issue
  end
end
