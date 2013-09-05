# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  def title(page_title = nil, subtitle = nil, show_title = true, interpolations={})
    content_for(:title) {page_title ? page_title.to_s : default_title(interpolations)}
    content_for(:subtitle) { subtitle }
    @show_title = show_title
  end

  def default_title(interpolations={})
    translate_controller_action(action_name, controller_name, interpolations)
  end

  def show_title?
    @show_title
  end

  private

  def translate_controller_action(action, resource, interpolations={})
    I18n.t([resource, action].join("."), interpolations)
  end
end
