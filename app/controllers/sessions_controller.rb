class SessionsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => :new

  def new
    redirect_to buckets_path if current_user

    render :layout => false
  end

  def destroy
    logout!
    redirect_to root_url
  end
end
