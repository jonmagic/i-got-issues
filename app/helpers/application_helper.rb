module ApplicationHelper
  def navbar_link_class(controller, actions)
    "active" if params[:controller] == controller.to_s && Array(actions).include?(params[:action].to_sym)
  end

  def github_issue_url(issue)
    "https://github.com/#{issue.owner}/#{issue.repository}/issues/#{issue.number}"
  end

  def github_issue_nwo_id(issue)
    "#{issue.owner}/#{issue.repository}##{issue.number}"
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

  def teams_link(team)
    text, css_class = if team.present? && team.name.present?
      string  = octicon("jersey")
      string += content_tag :span, team.organization, :class => "teams-link-organization"
      string += content_tag :span, "/", :class => "divider"
      string += content_tag :span, team.name, :class => "teams-link-name"
      string += content_tag :span, "(change)", :class => "teams-link-change"
      [string, "teams-link"]
    else
      ["Teams", ""]
    end

    link_to text, teams_path, :class => css_class
  end
end
