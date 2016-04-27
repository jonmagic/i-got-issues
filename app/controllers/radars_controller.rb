class RadarsController < ApplicationController
  before_filter :authorize_read_team!

  def show
    @did = []
    @doing = []

    team.buckets.each do |bucket|
      PrioritizedIssue.bucket(bucket).each do |prioritized_issue|
        if prioritized_issue.assignee == params[:id]
          if prioritized_issue.closed?
            @did.push(prioritized_issue.issue)
          else
            @doing.push(prioritized_issue.issue)
          end
        end
      end
    end
  end
end
