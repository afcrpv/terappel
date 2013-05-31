module ApplicationHelper
  def present(object, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    presenter
  end

  def errors_for(object, message=nil)
    unless object.errors.blank?
      contents = ActiveSupport::SafeBuffer.new
      contents << content_tag(:button, "&times;".html_safe, type: "button", class: "close", data: {dismiss: "alert"})
      title = message.blank? ? "Des erreurs ont été trouvées, vérifiez :" : message
      contents << content_tag(:h4, title)
      errors = ActiveSupport::SafeBuffer.new
      object.errors.full_messages.each do |error|
        errors << content_tag(:li, error.html_safe)
      end
      contents << content_tag(:ul, errors)
    end
    content_tag :div, contents, class: "alert alert-error alert-block #{object.class.name.humanize.downcase}-errors"
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
