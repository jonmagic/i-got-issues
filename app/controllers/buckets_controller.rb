class BucketsController < ApplicationController
  before_filter :authorize_read_team!
  before_action :set_bucket, :only => [:edit, :update]

  def index
    if @team.buckets.any?
      team_members
      @buckets = @team.buckets
      @columns = 12 / (@buckets.length > 0 ? @buckets.length : 1)
    elsif @team.present?
      if team_member?
        redirect_to new_team_buckets_path(@team)
      else
        redirect_to teams_path
      end
    else
      redirect_to teams_path
    end
  end

  def new
    @bucket = Bucket.new
  end

  def edit
  end

  def create
    bucket = BucketCreator.process(current_user, params)

    redirect_to team_path(bucket.team), :notice => "Bucket was successfully created."
  end

  def update
    bucket = BucketUpdater.process(current_user, params)

    respond_to do |format|
      format.json { render :json => bucket }
      format.html { redirect_to team_path(bucket.team) }
    end
  end

  def destroy
    bucket = BucketDestroyer.process(current_user, params)

    redirect_to team_path(bucket.team), :notice => "Bucket was successfully destroyed."
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_bucket
    @bucket = @team.buckets.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def bucket_params
    params.require(:bucket).permit(:name, :row_order_position)
  end
end
