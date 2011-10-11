class ApplicationController < ActionController::Base
  protect_from_forgery

  def redirect_with_flash(resource, path=nil)
    path = resource unless path
    resource = resource[1] if resource.class == Array
    redirect_to path, :notice => flash_message(resource)
  end

  private

  def flash_message(instance)
    @flash_message = t("flash.#{self.action_name}", :resource => instance.class.name)
  end
end
