class BucketsController < ApplicationController
  before_filter :authorize_read_team!
  before_filter :authorize_write_team!, :only => [:new, :create, :edit, :update, :destroy]

  def index
    if team.buckets.any?
      @buckets = team.buckets
      @columns = 12 / (@buckets.length > 0 ? @buckets.length : 1)
    else
      redirect_to new_team_bucket_path(team)
    end
  end

  def new
    @bucket = Bucket.new
  end

  def edit
    @bucket = team.buckets.find(params[:id])
  end

  def create
    BucketService.create(team, bucket_params)

    redirect_to team_path(team), :notice => "Bucket was successfully created."
  end

  def update
    BucketService.new(params[:id]).update(bucket_params)

    respond_to do |format|
      format.json { render :json => bucket }
      format.html { redirect_to team_path(team) }
    end
  end

  def destroy
    BucketService.new(params[:id]).destroy

    redirect_to team_path(team), :notice => "Bucket was successfully destroyed."
  end

private
  # Only allow a trusted parameter "white list" through.
  def bucket_params
    params.require(:bucket).permit(:name, :row_order_position)
  end
end
