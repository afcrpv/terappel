require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate_user!
  enable_authorization unless: :devise_controller?
  before_filter :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::Unauthorized do |exception|
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    redirect_to login_url, alert: exception.message
  end

  before_filter :find_dossier_for_search

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) {|u| u.permit(:username, :password, :remember_me)}
  end

  def find_dossier_for_search
    if params[:codedossier]
      @search = Dossier.where(code: params[:codedossier]).first rescue nil
      if @search
        redirect_to edit_dossier_path(@search)
      else
        redirect_to try_new_dossier_path(code: params[:codedossier])
      end
    end
  end
end
