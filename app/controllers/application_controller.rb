class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :require_login

  def redirect_with_flash(instance)
    redirect_to instance, :notice => flash_message(instance)
  end

  private

  def flash_message(instance)
    @flash_message = t("flash.#{self.action_name}", :resource => instance.class.name)
  end

  def not_authenticated
    redirect_to login_path, :alert => t('sessions.unauthenticated')
  end
end
