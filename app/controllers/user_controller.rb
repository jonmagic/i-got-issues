class UserController < ApplicationController
  def set_team
    if current_user.github_client.team_member?(params[:team_id], current_user.login)
      current_user.update_attribute :team_id, params[:team_id]
    end

    redirect_to team_buckets_path(current_user.team)
  end
end
