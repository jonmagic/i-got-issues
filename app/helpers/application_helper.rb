module ApplicationHelper
  def navbar_link_class(section)
    "active" if params[:controller] == section.to_s
  end

  def github_issue_url(issue)
    "https://github.com/#{issue.github_owner}/#{issue.github_repository}/issues/#{issue.github_id}"
  end
end
