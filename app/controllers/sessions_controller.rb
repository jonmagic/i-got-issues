class SessionsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => :new

  def new
    if current_user
      if current_user.team
        redirect_to team_path(:team_id => current_user.team.id)
      else
        redirect_to teams_path
      end
    else
      render :layout => false
    end
  end

  def destroy
    logout!
    redirect_to root_url
  end
end
