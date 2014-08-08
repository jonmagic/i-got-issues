class BucketsController < ApplicationController
  before_filter :authorize_read_team!
  before_filter :authorize_write_team!, :only => [:new, :create, :edit, :update, :destroy]
  after_filter  :notify_team_subscribers, :only => [:create, :update, :destroy]

  def index
    if team.buckets.any?
      @buckets   = team.buckets
      @columns   = 12 / (@buckets.length > 0 ? @buckets.length : 1)
      @assignees = team.members.map &:login
    else
      redirect_to new_team_bucket_path(team)
    end
  end

  def new
    @bucket = Bucket.new
  end

  def edit
    @bucket = bucket_service.for_bucket_by_id(params[:id]).bucket
  end

  def create
    bucket_service.create_bucket_with_params(bucket_params)

    redirect_to team_path(team), :notice => "Bucket was successfully created."
  end

  def update
    bucket_service.
      for_bucket_by_id(params[:id]).
      update_bucket_with_params(bucket_params)

    respond_to do |format|
      format.json { render :json => bucket_service.bucket }
      format.html { redirect_to team_path(team) }
    end
  end

  def destroy
    bucket_service.for_bucket_by_id(params[:id]).move_issues_and_remove_bucket

    redirect_to team_path(team), :notice => "Bucket was successfully destroyed."
  end

private
  # Only allow a trusted parameter "white list" through.
  def bucket_params
    params.require(:bucket).permit(:name, :row_order_position)
  end

  def bucket_service
    @bucket_service ||= \
      BucketService.for_user_and_team(current_user, team)
  end
end
