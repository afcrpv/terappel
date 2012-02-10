module ApplicationHelper
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
