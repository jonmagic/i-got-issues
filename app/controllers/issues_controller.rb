class IssuesController < ApplicationController
  before_action :set_issue, only: [:show, :edit, :update, :destroy]

  # GET /issues
  def index
    @issues = Issue.all
  end

  # GET /issues/1
  def show
  end

  # GET /issues/new
  def new
    @issue = if github_issue
      Issue.new \
        :title             => github_issue["title"],
        :github_owner      => parsed_url.github_owner,
        :github_repository => parsed_url.github_repository,
        :github_id         => parsed_url.github_id,
        :state             => github_issue["state"],
        :assignee          => github_issue["assignee"] ? github_issue["assignee"]["login"] : nil
    else
      Issue.new
    end
  end

  # GET /issues/1/edit
  def edit
  end

  # POST /issues
  def create
    @issue = Issue.new(issue_params)

    if @issue.save
      redirect_to @issue, notice: 'Issue was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /issues/1
  def update
    if @issue.update(issue_params)
      redirect_to @issue, notice: 'Issue was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /issues/1
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
    params.require(:issue).permit(:title, :github_owner, :github_repository, :github_id, :state, :assignee)
  end

  def parsed_url
    UrlParser.new(params[:url]) if params[:url]
  end

  def github_issue
    return unless parsed_url

    current_user.github_client.issue \
      "#{parsed_url.github_owner}/#{parsed_url.github_repository}",
      parsed_url.github_id
  end
end
