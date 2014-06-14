class SessionsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => :new

  def new
    if current_user
      redirect_to team_buckets_path(current_user.team)
    else
      render :layout => false
    end
  end

  def destroy
    logout!
    redirect_to root_url
  end
end
