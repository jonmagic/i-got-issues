class PrioritizedIssuesController < ApplicationController
  def create
    if github_issue
      PrioritizedIssue.create \
        :bucket             => current_user.buckets.last,
        :row_order_position => :last,
        :issue_attributes   => {
          :title      => github_issue["title"],
          :owner      => parsed_url.owner,
          :repository => parsed_url.repository,
          :number     => parsed_url.number,
          :state      => github_issue["state"],
          :assignee   => github_issue["assignee"] ? github_issue["assignee"]["login"] : nil
        }
    end

    redirect_to buckets_path
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
end
