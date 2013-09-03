class DossiersController < ApplicationController
  respond_to :html
  respond_to :pdf, only: [:show, :index]
  respond_to :xls, only: [:show, :index]
  respond_to :json, only: [:produits, :indications, :dcis]

  rescue_from CanCan::Unauthorized do |exception|
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    redirect_to dossiers_url, alert: "Vous ne pouvez pas modifier un dossier n'appartenant pas à votre CRPV !"# exception.message
  end

  before_action :set_centre
  before_action :set_dossier, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource :dossier

  helper_method :date_appel, :date_reelle_accouchement, :date_dernieres_regles, :date_debut_grossesse, :date_accouchement_prevu, :evolutions, :date_naissance, :date_recueil_evol

  def produits
    @produits = params[:produit_id] ? Produit.where(id: params[:produit_id]) : Produit.search_by_name(params[:q])
    respond_with @produits.map(&:name_and_id)
  end

  def indications
    @indications = params[:indication_id] ? Indication.where(id: params[:indication_id]) : Indication.search_by_name(params[:q])
    respond_with @indications.map(&:name_and_id)
  end

  def dcis
    @dcis = params[:dci_id] ? Dci.where(id: params[:dci_id]) : Dci.search_by_name(params[:q])
    respond_with @dcis.map(&:name_and_id)
  end

  def index
    @dossiers = @dossiers.includes([:motif, :bebes, :produits]).limit(10)
    @decorated_dossiers = @dossiers.decorate
    respond_with @dossiers do |format|
      format.html
      format.xls
      format.pdf do
        pdf = DossiersPdf.new(@decorated_dossiers, view_context)
        send_data pdf.render, filename: "dossiers.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  def show
    @decorated_dossier = @dossier.decorate
    respond_with @dossier do |format|
      format.html {render layout: false}
      format.pdf do
        pdf = DossierPdf.new(@dossier, @decorated_dossier, view_context)
        send_data pdf.render, filename: "dossier_#{@dossier.code}.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  def new
    @dossier = Dossier.new(code: params[:code], centre_id: current_user.centre_id)

    respond_with @dossier
  end

  def create
    @dossier = Dossier.create(dossier_params)
    if params[:_continue]
      location = edit_dossier_path(@dossier)
    elsif params[:_add_another]
      location = new_dossier_path
    else
      location = dossiers_url
    end
    respond_with @dossier, location: location
  end

  def edit
    respond_with @dossier
  end

  def update
    if params[:_continue]
      location = edit_dossier_path(@dossier, current_tab: params[:dossier][:current_tab])
    elsif params[:_add_another]
      location = new_dossier_path
    else
      location = dossiers_url
    end
    @dossier.update(dossier_params)
    respond_with @dossier, location: location
  end

  def destroy
    @dossier.destroy
    respond_with @dossier, location: dossiers_path
  end

  private

  def interpolation_options
    { resource_name: "Dossier #{@dossier.code}" }
  end

  def set_centre
    @centre = current_user.centre
  end

  def set_dossier
    @dossier = Dossier.includes({expositions: [:produit, :indication]}).find_by_code(params[:id])
  end

  def date_appel
    @date_appel ||= params[:id] && @dossier.date_appel? ? l(@dossier.date_appel) : ""
  end

  def date_dernieres_regles
    @date_dernieres_regles ||= params[:id] && @dossier.date_dernieres_regles? ? l(@dossier.date_dernieres_regles) : ""
  end

  def date_debut_grossesse
    @date_debut_grossesse ||= params[:id] && @dossier.date_debut_grossesse? ? l(@dossier.date_debut_grossesse) : ""
  end

  def date_reelle_accouchement
    @date_reelle_accouchement ||= params[:id] && @dossier.date_reelle_accouchement? ? l(@dossier.date_reelle_accouchement) : ""
  end

  def date_accouchement_prevu
    @date_accouchement_prevu ||= params[:id] && @dossier.date_accouchement_prevu? ? l(@dossier.date_accouchement_prevu) : ""
  end

  def date_naissance
    @date_naissance ||= params[:id] && @dossier.date_naissance? ? l(@dossier.date_naissance) : ""
  end

  def date_recueil_evol
    @date_recueil_evol ||= params[:id] && @dossier.date_recueil_evol? ? l(@dossier.date_recueil_evol) : ""
  end

  def evolutions
    @evolutions = Evolution.all
  end

  def dossier_params
    params.require(:dossier).permit(:date_appel, :centre_id, :user_id, :current_tab, :code, :a_relancer, :relance_counter, :categoriesp_id,
      :motif_id, :modaccouch, :date_dernieres_regles, :date_reelle_accouchement, :date_accouchement_prevu, :date_debut_grossesse, :date_recueil_evol, :name, :prenom, :age, :antecedents_perso, :antecedents_fam, :ass_med_proc, :expo_terato, :tabac, :alcool, :fcs, :geu, :miu, :ivg, :img, :nai, :grsant, :age_grossesse, :terme, :path_mat, :comm_antecedents_perso, :comm_antecedents_fam, :comm_evol, :comm_expo, :commentaire, :toxiques, :date_naissance, :poids, :taille, :folique, :patho1t, :evolution, :imc,
      demandeur_attributes: [:correspondant_id],
      relance_attributes: [:correspondant_id],
      expositions_attributes: [:id, :expo_type_id, :expo_nature_id, :produit_id, :indication_id, :voie_id, :dose, :de, :de_date, :a, :a_date, :duree, :de2, :de2_date, :a2, :a2_date, :duree2, :expo_terme_id], bebes_attributes: [:id, :age, :sexe, :poids, :taille, :pc, :apgar1, :apgar5, :malformation, :pathologie, :malformation_tokens, :pathologie_tokens])
  end
end
