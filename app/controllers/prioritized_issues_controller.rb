class PrioritizedIssuesController < ApplicationController
  def move_to_bucket
    prioritized_issue = PrioritizedIssue.find(params[:prioritized_issue_id])
    bucket = Bucket.find(params[:prioritized_issue][:bucket_id])
    prioritized_issue.move_to_bucket(bucket, params[:prioritized_issue][:row_order_position].to_i)

    render :json => prioritized_issue
  end
end
