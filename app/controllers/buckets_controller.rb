class BucketsController < ApplicationController
  def index
    @buckets     = BucketsFinder.process(current_user, params)
    @team_finder = TeamFinder.new(current_user, params)
    @team        = @team_finder.process

    if @buckets.any?
      @team_members = TeamMembersFinder.process(current_user, params)
      @columns = 12 / (@buckets.length > 0 ? @buckets.length : 1)
    elsif @team_finder.user_write_permission?
      redirect_to new_team_buckets_path(@team)
    else
      redirect_to teams_path
    end
  end

  def new
    @bucket = Bucket.new
  end

  def edit
    @bucket = BucketFinder.process(current_user, params)
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
end
