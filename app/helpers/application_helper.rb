module ApplicationHelper
  def actions(&block)
    content_tag :nav, class: "action_links" do
      content_tag :ul, &block
    end
  end

  def action_button(object, action)
    method = action == "destroy" ? :delete : :get
    confirm = action == "destroy" ? t("shared.action_links.confirm") : nil
    if can? action.to_sym, object
      link_to image_tag("icons/#{action}.png", :alt => t("shared.action_links.#{action}")),
        action_path(object, action),
        :method => method, :confirm => confirm, :class => "#{action}_button"
    end
  end

  private

  def action_path(object, action)
    action = action == "edit" ? action : nil
    polymorphic_path(object, :action => action)
  end
end
