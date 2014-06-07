module ApplicationHelper
  def navbar_link_class(section)
    "active" if params[:controller] == section.to_s
  end
end
