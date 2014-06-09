class PrioritizedIssuesController < ApplicationController
  before_action :load_team, :only => :update
  
  def create
    if github_issue
      issue = Issue.from_attributes({
        :title      => github_issue["title"],
        :owner      => parsed_url.owner,
        :repository => parsed_url.repository,
        :number     => parsed_url.number,
        :state      => github_issue["state"],
        :assignee   => github_issue["assignee"] ? github_issue["assignee"]["login"] : nil,
        :labels     => github_issue["labels"].map {|label| label[:name] }
      })

      prioritized_issue = PrioritizedIssue.where(
        :bucket => current_user.buckets,
        :issue  => issue
      ).first_or_initialize

      prioritized_issue.update_attributes(
        :row_order_position => :last,
        :bucket => current_user.buckets.last
      ) if prioritized_issue.new_record?
    end

    redirect_to buckets_path
  end

  def update
    prioritized_issue = PrioritizedIssue.find(params[:id])
    prioritized_issue.issue.update(issue_params)

    render :partial => "buckets/issue", :locals => {:issue => prioritized_issue}
  end

  def destroy
    issue = Issue.find(params[:id])
    issue.destroy

    redirect_to buckets_path, :notice => 'Issue was successfully destroyed.'
  end

  def move_to_bucket
    prioritized_issue = PrioritizedIssue.find(params[:prioritized_issue_id])
    bucket = Bucket.find(params[:prioritized_issue][:bucket_id])
    prioritized_issue.move_to_bucket(bucket, params[:prioritized_issue][:row_order_position].to_i)

    render :json => prioritized_issue
  end

private

  def parsed_url
    UrlParser.new(params[:url]) if params[:url]
  end

  def github_issue
    return unless parsed_url

    current_user.github_client.issue \
      "#{parsed_url.owner}/#{parsed_url.repository}",
      parsed_url.number
  end

  # Only allow a trusted parameter "white list" through.
  def issue_params
    params.require(:prioritized_issue).permit(:title, :owner, :repository, :number, :state, :assignee)
  end

  def load_team
    team = current_user.github_client.team_members current_user.team_id
    @teammates = team.map {|member| member["login"] }
  end
end
