class SessionsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => :new

  def new
    redirect_to issues_path if current_user
  end

  def destroy
    logout!
    redirect_to root_url
  end
end
