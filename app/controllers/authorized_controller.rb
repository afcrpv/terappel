class AuthorizedController < ApplicationController
  before_filter :authenticate_user!
  check_authorization # This is for CanCan to ensure authorization is checked for any controller action

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    redirect_to root_url, :alert => exception.message
  end
end
