class BucketsController < ApplicationController
  before_action :set_bucket, :only => [:edit, :update, :destroy]

  def index
    @buckets = current_user.buckets
    @columns = 12 / (@buckets.length > 0 ? @buckets.length : 1)
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
      redirect_to @bucket, notice: 'Bucket was successfully created.'
    else
      render :new
    end
  end

  def update
    if @bucket.update(bucket_params)
      redirect_to @bucket, notice: 'Bucket was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @bucket.destroy
    redirect_to buckets_url, notice: 'Bucket was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bucket
      @bucket = Bucket.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def bucket_params
      params.require(:bucket).permit(:name, :row_order)
    end
end
