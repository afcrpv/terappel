module ApplicationHelper
  def sortable(column, title = nil, klass)
    title ||= column.titleize
    check_column = column == sort_column("", klass)
    direction = check_column && sort_direction("desc") == "asc" ? "desc" : "asc"
    css_class = check_column ? "sortable #{sort_direction("desc")}" : "sortable"
    icon_css_class = "icon-resize-vertical"
    wrap_css_class = nil
    case css_class
    when "sortable asc"
      icon_css_class = "icon-chevron-up"
    when "sortable desc"
      icon_css_class = "icon-chevron-down"
    when "sortable"
      icon_css_class = "icon-resize-vertical"
    end
    sort_icon = content_tag(:i, nil, class: icon_css_class)
    content = link_to :sort => column, :direction => direction do
      safe_concat sort_icon + " " + title
    end
    content_tag :th, content, class: wrap_css_class
  end

  def actions(&block)
    content_tag :nav, class: "action_links" do
      content_tag :ul, &block
    end
  end

  def action_button(object, action)
    method = action == "destroy" ? :delete : :get
    confirm = action == "destroy" ? t("shared.action_links.confirm") : nil
    icon_class = case action
                 when "show" then "eye-open"
                 when "edit" then "pencil"
                 when "destroy" then "remove"
                 end
    if can? action.to_sym, object
      link_to action_path(object, action), :method => method, :confirm => confirm, :class => "#{action}_button" do
        safe_concat "<i class='icon-#{icon_class}'></i>" + "<span style='display:none;'>#{t('shared.action_links.#{action}')}</span>"
      end
    end
  end

  private

  def action_path(object, action)
    action = action == "edit" ? action : nil
    polymorphic_path(object, :action => action)
  end
end
