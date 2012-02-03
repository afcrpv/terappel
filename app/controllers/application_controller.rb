class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :find_dossier_for_search

  def redirect_with_flash(resource, flash_type=:success, path=nil, message=nil)
    path = resource unless path
    resource = resource[1] if resource.class == Array
    message = flash_message(resource) unless message
    redirect_to path, flash: {"#{flash_type}" => message}
  end

  private

  def find_dossier_for_search
    if params[:codedossier]
      @search = Dossier.find(params[:codedossier]) rescue nil
      if @search
        redirect_to dossier_path(@search)
      else
        redirect_to new_dossier_path(:code => params[:codedossier])
      end
    end
  end

  def flash_message(instance)
    @flash_message = t("flash.#{self.action_name}", :resource => t('activerecord.models.' + instance.class.name.downcase).classify)
  end
end
