class UserController < ApplicationController
  def set_team
    if team.member?(current_user)
      current_user.update_attribute :team_id, params[:team_id]
    end

    redirect_to team_path(current_user.team)
  end
end
