class ImportController < ApplicationController
  before_filter :authorize_write_team!

  def index
    # just renders a form
  end

  def create
    prioritized_issue_service.
      import_issues_from_repository(params[:url], params[:labels], params[:state])

    redirect_to team_path(team)
  end

private

  def prioritized_issue_service
    @prioritized_issue_service ||= \
      PrioritizedIssueService.
        for_user_and_team(current_user, team)
  end
end
