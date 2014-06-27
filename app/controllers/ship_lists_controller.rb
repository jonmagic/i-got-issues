class ShipListsController < ApplicationController
  before_filter :authorize_read_team!

  def index
    @ship_lists = @team.ship_lists
  end

  def show
    @ship_list = @team.ship_list(params[:id])
  end
end
