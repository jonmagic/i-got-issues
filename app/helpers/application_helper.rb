module ApplicationHelper
  def navbar_link_class(section)
    "active" if params[:controller] == section.to_s
  end

  def github_issue_url(issue)
    "https://github.com/#{issue.owner}/#{issue.repository}/issues/#{issue.number}"
  end

  def github_user_url(issue)
    "https://github.com/#{issue.assignee}"
  end

  def github_repository_url(issue)
    "https://github.com/#{issue.owner}/#{issue.repository}"
  end
end
