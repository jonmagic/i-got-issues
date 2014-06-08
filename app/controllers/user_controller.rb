class UserController < ApplicationController
  def set_team
    if current_user.github_client.team_member?(params[:team_id], current_user.name)
      current_user.update_attribute :team_id, params[:team_id]
    end

    redirect_to buckets_path
  end
end
