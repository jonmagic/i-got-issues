class AuditEntriesController < ApplicationController
  before_filter :authorize_read_team!

  def index
    @entries = AuditEntry.by_team_id(team.id)

    respond_to do |format|
      format.json { render :json => @entries }
      format.html { render }
    end
  end
end
