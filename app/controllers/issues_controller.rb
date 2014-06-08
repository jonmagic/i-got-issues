class IssuesController < ApplicationController
  before_action :set_issue, :only => [:update, :destroy]

  def update
    if @issue.update(issue_params)
      redirect_to @issue, notice: 'Issue was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @issue.destroy
    redirect_to issues_url, notice: 'Issue was successfully destroyed.'
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_issue
    @issue = Issue.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def issue_params
    params.require(:issue).permit(:title, :owner, :repository, :number, :state, :assignee)
  end
end
