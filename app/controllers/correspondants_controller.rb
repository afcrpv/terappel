# encoding: UTF-8
class CorrespondantsController < ApplicationController
  before_action :find_centre
  load_and_authorize_resource :correspondant

  helper_method :form_title

  def index
    @correspondants = @centre.correspondants.where("LOWER(nom) like ?", "%#{params[:q]}%")
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
      format.js { render :new, layout: false}
    end
  end

  def create
    if @correspondant.save
      respond_to do |format|
        format.html { redirect_with_flash @correspondant, nil, :success, "Le correspondant #{@correspondant.fullname} a été créé." }
        format.js { render json: {:id => @correspondant.id, :label => @correspondant.fullname }}
      end
    else
      respond_to do |format|
        format.html { render :new, status: :not_acceptable }
        format.js { render :new, layout: false, status: :not_acceptable }
      end
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.js { render :edit, layout: false}
    end
  end

  def update
    if @correspondant.update_attributes(params[:correspondant])
      respond_to do |format|
        format.html { redirect_with_flash @correspondant, nil, :success, "Le correspondant #{@correspondant.fullname} a été mis à jour."}
        format.js { render json: {:id => @correspondant.id, :label => @correspondant.fullname }}
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :not_acceptable }
        format.js { render :edit, layout: false, status: :not_acceptable }
      end
    end
  end

  private

  def correspondant_params
    params.require(:correspondant).permit :specialite_id, :qualite_id, :formule_id, :centre_id, :nom, :adresse, :cp, :ville, :telephone, :fax, :poste, :email, :fullname
  end

  def find_centre
    @centre = current_user.centre
  end

  def form_title
    @form_title ||= params[:id] && params[:id].present? ? "#{@correspondant.fullname}" : "Nouveau correspondant"
  end
end
