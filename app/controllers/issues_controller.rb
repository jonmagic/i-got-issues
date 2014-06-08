class IssuesController < ApplicationController
  before_action :set_issue, :only => [:update, :destroy]

  def new
    @issue = if github_issue
      Issue.new \
        :title      => github_issue["title"],
        :owner      => parsed_url.owner,
        :repository => parsed_url.repository,
        :number     => parsed_url.number,
        :state      => github_issue["state"],
        :assignee   => github_issue["assignee"] ? github_issue["assignee"]["login"] : nil
    else
      Issue.new
    end
  end

  def create
    @issue = Issue.new(issue_params)

    if @issue.save
      redirect_to @issue, notice: 'Issue was successfully created.'
    else
      render :new
    end
  end

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

  def parsed_url
    UrlParser.new(params[:url]) if params[:url]
  end

  def github_issue
    return unless parsed_url

    current_user.github_client.issue \
      "#{parsed_url.owner}/#{parsed_url.repository}",
      parsed_url.number
  end
end
