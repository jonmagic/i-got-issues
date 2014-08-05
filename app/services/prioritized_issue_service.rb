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
    end
  end

  # Public: Updates Issue with params and then updates issue on GitHub.
  #
  # params - Hash of attributes (:state, :assignee, ...)
  #
  # Returns a PrioritizedIssue.
  def update_issue_with_params(params)
    prioritized_issue.issue.update(params)
    issue_updater.from_issue(prioritized_issue.issue)
    self.prioritized_issue = prioritized_issue.reload
  end

  # Public: Removes a PrioritizedIssue from Team's buckets.
  #
  # Returns a PrioritizedIssue.
  def remove_prioritized_issue
    prioritized_issue.destroy
  end

  # Public: Moves PrioritizedIssue to a position in a Bucket.
  #
  # position - Integer representing new position
  # bucket   - Bucket instance
  #
  # Returns a PrioritizedIssue.
  def move_prioritized_issue_to_position_in_bucket(position, bucket)
    prioritized_issue.move_to_bucket(bucket, position)
  end

  # Public: Update Issue with values from GitHub.
  #
  # Returns a PrioritizedIssue.
  def update_issue_with_values_from_github
    issue_importer.from_issue(prioritized_issue.issue)
    self.prioritized_issue = prioritized_issue.reload
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
end
