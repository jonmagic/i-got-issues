module ApplicationHelper
  def navbar_link_class(controller, action)
    "active" if params[:controller] == controller.to_s && params[:action] == action.to_s
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

  def octicon(code)
    content_tag :span, '', :class => "octicon octicon-#{code.to_s.dasherize}"
  end
end
