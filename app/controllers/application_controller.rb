class ApplicationController < ActionController::Base
  protect_from_forgery :with => :exception

  before_filter :authenticate_user!

  helper_method :logged_in?
  helper_method :current_user
  helper_method :current_service
  helper_method :team_member?

  rescue_from "Octokit::NotFound" do |exception|
    redirect_to root_path
  end

  protected
  def current_user
    @current_user ||= begin
      if session.has_key?(:user_id)
        user = User.find(session[:user_id])
        user.github_client = Octokit::Client.new(:access_token => session[:oauth_token])
        user
      end
    end
  rescue ActiveRecord::RecordNotFound
    session[:user_id] = nil
  end

  def current_service
    if session.has_key?(:service_id)
      @current_service ||= Service.where(user_id: session[:user_id], id: session[:service_id]).first
    end
  rescue ActiveRecord::RecordNotFound
    session[:service_id] = nil
  end

  def current_user?
    !!current_user
  end

  def logged_in?
    current_user?
  end

  def authenticate_user!
    if session.has_key?(:user_id)
      current_user
    else
      session[:redirect_to] = request.path
      redirect_to root_path
    end
  end

  def logout!
    @current_user = nil
    reset_session
  end

  def team_members
    @team_members ||= begin
      current_user.
        github_client.
        team_members(params[:team_id]).
        map {|attributes| TeamMember.new(attributes) }
    end
  end

  def team
    @team ||= begin
      team = Team.new(current_user.github_client.team(params[:team_id]))
      team.members = team_members
      team
    end
  end

  def authorize_read_team!
    unless team_members
      redirect_to teams_path
    end
  end

  def team_member?
    team_members.detect {|team_member| team_member == current_user.login }
  end

  def authorize_write_team!
    unless team_member?
      redirect_to team_path(team)
    end
  end
end
