class BucketsController < ApplicationController
  before_action :set_bucket, :only => [:edit, :update, :destroy]

  def index
    if current_user.buckets.any?
      load_team
      @buckets = current_user.buckets
      @columns = 12 / (@buckets.length > 0 ? @buckets.length : 1)
    elsif current_user.team_id.present?
      redirect_to new_team_bucket_path(current_user.team)
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
    @bucket = Bucket.new(bucket_params)
    @bucket.team_id = current_user.team_id

    if @bucket.save
      redirect_to team_buckets_path(current_user.team), :notice => "Bucket was successfully created."
    else
      render :new
    end
  end

  def update
    @bucket.update(bucket_params)

    respond_to do |format|
      format.json { render :json => @bucket }
      format.html { redirect_to team_buckets_path(current_user.team) }
    end
  end

  def destroy
    new_bucket = current_user.buckets.where.not(:id => @bucket.id).last
    @bucket.issues.each {|issue| issue.move_to_bucket(new_bucket) }
    @bucket.destroy
    redirect_to team_buckets_path(current_user.team), :notice => "Bucket was successfully destroyed."
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_bucket
    @bucket = current_user.team.buckets.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def bucket_params
    params.require(:bucket).permit(:name, :row_order_position)
  end

  def load_team
    team = current_user.github_client.team_members current_user.team_id
    @teammates = team.map {|member| member["login"] }
  end
end
