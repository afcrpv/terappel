class ApplicationController < ActionController::Base
  protect_from_forgery

  check_authorization # This is for CanCan to ensure authorization is checked for any controller action

  def redirect_with_flash(resource, path=nil)
    path = resource unless path
    resource = resource[1] if resource.class == Array
    redirect_to path, :notice => flash_message(resource)
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  private

  def flash_message(instance)
    @flash_message = t("flash.#{self.action_name}", :resource => instance.class.name)
  end

  def not_authenticated
    redirect_to login_path, :alert => t('sessions.unauthenticated')
  end
end
