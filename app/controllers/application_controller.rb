class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :require_login
  check_authorization # This is for CanCan to ensure authorization is checked for any controller action

  def redirect_with_flash(instance)
    redirect_to instance, :notice => flash_message(instance)
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
