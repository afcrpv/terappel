class CorrespondantsController < ApplicationController
  before_action :find_centre
  load_and_authorize_resource

  helper_method :form_title

  def index
    @correspondants = @centre.correspondants.where('LOWER(nom) like ?', "%#{params[:q]}%")
    respond_to do |format|
      format.json { render json: @correspondants.map(&:fullname_and_id) }
    end
  end

  def show
  end

  def new
    @correspondant = Correspondant.new(centre_id: @centre.id)
    respond_to do |format|
      format.html
      format.js { render layout: false }
    end
  end

  def create
    @correspondant = Correspondant.new(correspondant_params)
    if @correspondant.save
      respond_to do |format|
        format.html { redirect_with_flash @correspondant, nil, :success, "Le correspondant #{@correspondant.fullname} a été créé." }
        format.js { render json: { id: @correspondant.id, label: @correspondant.fullname } }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.js { render layout: false, status: :not_acceptable }
      end
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.js { render layout: false }
    end
  end

  def update
    if @correspondant.update(correspondant_params)
      respond_to do |format|
        format.html { redirect_with_flash @correspondant, nil, :success, "Le correspondant #{@correspondant.fullname} a été mis à jour." }
        format.js { render json: { id: @correspondant.id, label: @correspondant.fullname } }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.js { render :edit, layout: false, status: :not_acceptable }
      end
    end
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
