class CorrespondantsController < ApplicationController
  respond_to :html, :json
  respond_to :js, only: [:create, :update]

  before_action :find_centre
  load_and_authorize_resource

  helper_method :form_title

  def index
    @correspondants = @centre.correspondants.where('LOWER(nom) like ?', "%#{params[:q]}%")
    respond_with @correspondants do |format|
      format.html
      format.json { render json: @correspondants.map(&:fullname_and_id) }
    end
  end

  def show
    respond_with @correspondant
  end

  def new
    @correspondant = Correspondant.new(centre_id: @centre.id)
    respond_modal_with @correspondant
  end

  def create
    @correspondant = Correspondant.create(correspondant_params)
    respond_with @correspondant
  end

  def edit
    respond_modal_with @correspondant
  end

  def update
    @correspondant.update(correspondant_params)
    respond_with @correspondant
  end

  private

  def correspondant_params
    params.require(:correspondant).permit(:specialite_id, :qualite_id, :formule_id, :centre_id, :nom, :adresse, :cp, :ville, :telephone, :fax, :email, :fullname, :centre_id)
  end

  def find_centre
    @centre = current_user.centre
  end

  def form_title
    @form_title ||= params[:id] && params[:id].present? ? @correspondant.fullname.to_s : 'Nouveau correspondant'
  end
end
