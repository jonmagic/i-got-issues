class PrioritizedIssuesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  before_action :load_team, :only => [:update, :sync]

  def create
    if issue = issue_sync.from_url(params[:url])
      prioritized_issue = PrioritizedIssue.where(
        :bucket => current_user.buckets,
        :issue  => issue
      ).first_or_initialize

      prioritized_issue.update_attributes(
        :row_order_position => :last,
        :bucket => current_user.buckets.last
      ) if prioritized_issue.new_record?
    end

    if params[:return]
      redirect_to params[:url]
    else
      redirect_to buckets_path
    end
  end

  def update
    prioritized_issue = current_user.issues.find(params[:id])
    prioritized_issue.issue.update(issue_params)
    issue_sync.from_issue(prioritized_issue.issue)

    render :partial => "buckets/issue", :locals => {:issue => prioritized_issue}
  end

  def destroy
    prioritized_issue = current_user.issues.find(params[:id])
    prioritized_issue.destroy

    redirect_to buckets_path, :notice => 'Issue was successfully destroyed.'
  end

  # Archives all closed, non-archived issues for the current user.
  #
  # Note: In the future, when issues aren't limited to the user's team ID,
  # this will have to be scoped to the current team.
  def archive
    current_user.issues.closed.where(:archived_at => nil).update_all :archived_at => Time.now

    head :ok
  end

  def move_to_bucket
    prioritized_issue = current_user.issues.find(params[:prioritized_issue_id])
    bucket = current_user.buckets.find(params[:prioritized_issue][:bucket_id])
    prioritized_issue.move_to_bucket(bucket, params[:prioritized_issue][:row_order_position].to_i)

    render :json => prioritized_issue
  end

  def sync
    prioritized_issue = current_user.issues.find(params[:prioritized_issue_id])
    issue_sync.from_issue(prioritized_issue.issue)

    render :partial => "buckets/issue", :locals => {:issue => prioritized_issue}
  end

private
  # Only allow a trusted parameter "white list" through.
  def issue_params
    params.require(:prioritized_issue).permit(:title, :owner, :repository, :number, :state, :assignee)
  end

  def load_team
    team = current_user.github_client.team_members current_user.team_id
    @teammates = team.map {|member| member["login"] }
  end

  def issue_sync
    @issue_sync ||= IssueSync.new(current_user.github_client)
  end
end
