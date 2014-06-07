class BucketsController < ApplicationController
  before_action :set_bucket, only: [:show, :edit, :update, :destroy]

  # GET /buckets
  def index
    @buckets = Bucket.rank(:row_order).all
    @columns = 12 / @buckets.length
  end

  # GET /buckets/1
  def show
  end

  # GET /buckets/new
  def new
    @bucket = Bucket.new
  end

  # GET /buckets/1/edit
  def edit
  end

  # POST /buckets
  def create
    @bucket = Bucket.new(bucket_params)

    if @bucket.save
      redirect_to @bucket, notice: 'Bucket was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /buckets/1
  def update
    if @bucket.update(bucket_params)
      redirect_to @bucket, notice: 'Bucket was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /buckets/1
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
