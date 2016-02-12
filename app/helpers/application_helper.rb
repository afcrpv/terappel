module ApplicationHelper
  def setup_search_form(builder)
    fields = builder.grouping_fields builder.object.new_grouping,
                                     object_name: 'new_object_name', child_index: 'new_grouping' do |f|
      render('grouping_fields', f: f)
    end
    content_for :document_ready, %{
      var search = new Search({grouping: "#{escape_javascript(fields)}"});
      $(document).on("click", "button.ransack_add_fields", function() {
        search.add_fields(this, $(this).data('fieldType'), $(this).data('content'));
        return false;
      });
      $(document).on("click", "button.remove_fields", function() {
        search.remove_fields(this);
        return false;
      });
      $(document).on("click", "button.nest_fields", function() {
        search.nest_fields(this, $(this).data('fieldType'));
        return false;
      });
    }.html_safe
  end

  def button_to_remove_fields(name, _f)
    content_tag :button, name, class: 'remove_fields btn btn-danger btn-sm'
  end

  def button_to_add_fields(name, f, type)
    new_object = f.object.send "build_#{type}"
    fields = f.send("#{type}_fields", new_object, child_index: "new_#{type}") do |builder|
      render(type.to_s + '_fields', f: builder)
    end
    content_tag :button, name, class: 'ransack_add_fields btn btn-success btn-sm', 'data-field-type' => type, 'data-content' => fields.to_s
  end

  def button_to_nest_fields(name, type)
    content_tag :button, name, :class => 'nest_fields btn btn-success btn-sm', 'data-field-type' => type
  end

  def errors_for(object, message = nil)
    unless object.errors.blank?
      contents = ActiveSupport::SafeBuffer.new
      contents << content_tag(:button, '&times;'.html_safe, type: 'button', class: 'close', data: { dismiss: 'alert' })
      title = message.blank? ? "Des erreurs ont été trouvées, vérifiez :" : message
      contents << content_tag(:h4, title)
      errors = ActiveSupport::SafeBuffer.new
      object.errors.messages.each do |field, message|
        if field == :base
          link = link_to('Exposition', '#', data: { field: 'dossier_expositions' })
          errors << content_tag(:li, [message, "dans l'onglet", link].join(' ').html_safe)
        else
          link = link_to(object.class.human_attribute_name(field).html_safe, '#', data: { field: "#{object.class.name.downcase}_#{field}" })
          errors << content_tag(:li, ['le champ', link, message].join(' ').html_safe)
        end
      end
      contents << content_tag(:ul, errors)
      content_tag :div, contents, class: "alert alert-danger alert-block #{object.class.name.humanize.downcase}-errors"
    end
  end

  def actions(&block)
    content_tag :nav, class: 'action_links' do
      content_tag :ul, &block
    end
  end

  def action_button(object, action)
    method = action == 'destroy' ? :delete : :get
    confirm = action == 'destroy' ? t('shared.action_links.confirm') : nil
    icon_class = case action
                 when 'show' then 'eye-open'
                 when 'edit' then 'pencil'
                 when 'destroy' then 'remove'
                 end
    if can? action.to_sym, object
      link_to action_path(object, action), method: method, confirm: confirm, class: "#{action}_button" do
        safe_concat "<i class='icon-#{icon_class}'></i>" + "<span style='display:none;'>#{t('shared.action_links.#{action}')}</span>"
      end
    end
  end

  private

  def action_path(object, action)
    action = action == 'edit' ? action : nil
    polymorphic_path(object, action: action)
  end
end
