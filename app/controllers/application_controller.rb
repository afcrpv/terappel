class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  check_authorization unless: :devise_controller?
  before_filter :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    redirect_to root_url, alert: exception.message
  end

  before_filter :find_dossier_for_search

  def redirect_with_flash(resource, path=nil, flash_type=:success, message=nil)
    path = resource unless path
    resource = resource[1] if resource.is_a?(Array)
    message = flash_message(resource) unless message
    redirect_to path, flash: {"#{flash_type}" => message}
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) {|u| u.permit(:username, :password, :remember_me)}
  end

  def find_dossier_for_search
    if params[:codedossier]
      @search = Dossier.find(params[:codedossier]) rescue nil
      if @search
        redirect_to dossier_path(@search)
      else
        redirect_to try_new_dossier_path(code: params[:codedossier])
      end
    end
  end

  def flash_message(instance)
    @flash_message = t("flash.#{self.action_name}", :resource => t('activerecord.models.' + instance.class.name.downcase).classify, :id => instance.to_param)
  end
end
