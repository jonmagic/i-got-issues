class BucketsController < ApplicationController
  before_filter :authorize_read_team!
  before_filter :authorize_write_team!, :only => [:create, :update, :destroy, :archive_closed_issues]
  before_action :set_bucket, :only => [:edit, :update, :destroy]

  def index
    if team.buckets.any?
      @buckets = @team.buckets
      @columns = 12 / (@buckets.length > 0 ? @buckets.length : 1)
    elsif team.present?
      if team.member?(current_user)
        redirect_to new_team_bucket_path(@team)
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
    @bucket = Bucket.new(bucket_params)
    @bucket.team_id = @team.id
    @bucket.row_order_position = :last

    if @bucket.save
      redirect_to team_path(@team), :notice => "Bucket was successfully created."
    else
      render :new
    end
  end

  def update
    @bucket.update(bucket_params)

    respond_to do |format|
      format.json { render :json => @bucket }
      format.html { redirect_to team_path(@team) }
    end
  end

  def destroy
    new_bucket = @team.buckets.where.not(:id => @bucket.id).last
    @bucket.issues.each {|issue| issue.move_to_bucket(new_bucket) }
    @bucket.destroy
    redirect_to team_path(@team), :notice => "Bucket was successfully destroyed."
  end

  # Archives all closed, non-archived issues for the current user.
  #
  # Note: In the future, when issues aren't limited to the user's team ID,
  # this will have to be scoped to the current team.
  def archive_closed_issues
    @team.issues.closed.where(:archived_at => nil).update_all :archived_at => Time.now.beginning_of_minute

    head :ok
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
