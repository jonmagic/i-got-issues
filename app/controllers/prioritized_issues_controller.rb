class PrioritizedIssuesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  before_filter :authorize_write_team!, :except => :sync

  def create
    if issue = issue_importer.from_url(params[:url])
      prioritized_issue = PrioritizedIssue.where(
        :bucket => @team.buckets,
        :issue  => issue
      ).first_or_initialize

      attributes = {:archived_at => nil}
      if prioritized_issue.new_record?
        attributes[:row_order_position] = :last
        attributes[:bucket] = @team.buckets.last
      end

      prioritized_issue.update_attributes(attributes)
    end

    if params[:return]
      redirect_to params[:url]
    else
      redirect_to team_path(@team)
    end
  end

  def update
    prioritized_issue = current_user.issues.find(params[:id])
    prioritized_issue.issue.update(issue_params)
    issue_updater.from_issue(prioritized_issue.issue)
    prioritized_issue.reload

    render :partial => "buckets/issue", :locals => {:issue => prioritized_issue}
  end

  def destroy
    prioritized_issue = @team.issues.find(params[:id])
    prioritized_issue.destroy

    redirect_to team_path(@team), :notice => 'Issue was successfully destroyed.'
  end

  def move_to_bucket
    prioritized_issue = current_user.issues.find(params[:prioritized_issue_id])
    bucket = @team.buckets.find(params[:prioritized_issue][:bucket_id])
    prioritized_issue.move_to_bucket(bucket, params[:prioritized_issue][:row_order_position].to_i)

    render :json => prioritized_issue
  end

  def sync
    prioritized_issue = current_user.issues.find(params[:prioritized_issue_id])
    issue_importer.from_issue(prioritized_issue.issue)
    prioritized_issue.reload

    render :partial => "buckets/issue", :locals => {:issue => prioritized_issue}
  end

private
  # Only allow a trusted parameter "white list" through.
  def issue_params
    params.require(:prioritized_issue).permit(:title, :owner, :repository, :number, :state, :assignee)
  end

  def issue_importer
    @issue_importer ||= IssueImporter.new(current_user.github_client)
  end

  def issue_updater
    @issue_updater ||= IssueUpdater.new(current_user.github_client)
  end
end
