class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :find_dossier_for_search
  helper_method :sort_column, :sort_direction

  def redirect_with_flash(resource, path=nil, flash_type=:success, message=nil)
    path = resource unless path
    resource = resource[1] if resource.is_a?(Array)
    message = flash_message(resource) unless message
    redirect_to path, flash: {"#{flash_type}" => message}
  end

  def sort_column(default,klass)
    klass.column_names.include?(params[:sort]) ? params[:sort] : default
  end

  def sort_direction(default)
    %w[asc desc].include?(params[:direction]) ? params[:direction] : default
  end

  private

  def find_dossier_for_search
    if params[:codedossier]
      @search = Dossier.find(params[:codedossier]) rescue nil
      if @search
        redirect_to edit_dossier_path(@search)
      else
        redirect_to new_dossier_path(:code => params[:codedossier])
      end
    end
  end

  def flash_message(instance)
    @flash_message = t("flash.#{self.action_name}", :resource => t('activerecord.models.' + instance.class.name.downcase).classify, :id => instance.to_param)
  end
end
