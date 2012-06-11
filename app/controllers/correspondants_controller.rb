# encoding: UTF-8

class CorrespondantsController < AuthorizedController
  respond_to :html, :js
  before_filter :find_centre
  load_and_authorize_resource :correspondant

  def show
  end

  def new
    @correspondant = Correspondant.new(centre_id: @centre.id)
  end

  def create
    flash[:notice] = "Le correspondant #{@correspondant.fullname} a été créé." if @correspondant.save
    respond_with @correspondant, layout: !request.xhr?
  end

  def edit
  end

  def update
    flash[:notice] = "Le correspondant #{@correspondant.fullname} a été mis à jour." if @correspondant.update_attributes(params[:correspondant])
    respond_with @correspondant, layout: !request.xhr?
  end

  private

  def find_centre
    @centre = current_user.centre
  end
end
