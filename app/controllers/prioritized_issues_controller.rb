class PrioritizedIssuesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:create, :bookmarklet_legacy]
  before_filter :authorize_read_team!, :except => [:bookmarklet_legacy, :new]
  before_filter :authorize_write_team!, :except => [:sync, :bookmarklet_legacy, :new]
  before_filter :load_assignees, :only => [:update, :sync]
  after_filter  :notify_team_subscribers, :only => [:create, :update, :destroy, :move_to_bucket, :sync]

  def create
    prioritized_issue_service.import_issue_from_url(params[:url])

    if params[:return]
      redirect_to params[:url]
    else
      redirect_to team_path(team)
    end
  end

  def update
    prioritized_issue = \
      prioritized_issue_service.
        for_prioritized_issue_by_id(params[:id]).
        update_issue_with_params(issue_params)

    render :partial => "buckets/issue", :locals => {:issue => prioritized_issue}
  end

  def destroy
    prioritized_issue_service.
      for_prioritized_issue_by_id(params[:id]).
      remove_prioritized_issue

    redirect_to team_path(@team), :notice => 'Issue was successfully destroyed.'
  end

  def move_to_bucket
    bucket   = team.buckets.find(params[:prioritized_issue][:bucket_id])
    position = params[:prioritized_issue][:row_order_position].to_i

    prioritized_issue_service.
      for_prioritized_issue_by_id(params[:prioritized_issue_id]).
      move_prioritized_issue_to_position_in_bucket(position, bucket)

    render :json => prioritized_issue_service.prioritized_issue
  end

  def sync
    prioritized_issue_service.
      for_prioritized_issue_by_id(params[:prioritized_issue_id]).
      update_issue_with_values_from_github

    render :partial => "buckets/issue",
           :locals => {:issue => prioritized_issue_service.prioritized_issue}
  end

  def bookmarklet_legacy
    redirect_to \
      new_prioritized_issue_path(:url => params[:url], :return => params[:return]),
      :notice => I18n.t("import_issues.select_a_team")
  end

  def new
    @url = params[:url]
    @return = params[:return]
    @organizations = current_user.
      github_client.
      user_teams.
      map {|t| Team.new(t) }.
      group_by {|t| t.organization.downcase }.
      sort
  end

private
  # Only allow a trusted parameter "white list" through.
  def issue_params
    params.require(:prioritized_issue).permit(:title, :owner, :repository, :number, :state, :assignee)
  end

  def prioritized_issue_service
    @prioritized_issue_service ||= \
      PrioritizedIssueService.
        for_user_and_team(current_user, team)
  end

  def load_assignees
    @assignees = team_members.map &:login
  end
end
