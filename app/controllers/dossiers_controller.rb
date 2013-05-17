class DossiersController < ApplicationController
  before_action :set_centre
  before_action :set_dossier, only: [:show, :edit]
  load_and_authorize_resource :dossier

  helper_method :date_appel, :date_reelle_accouchement, :date_dernieres_regles, :date_debut_grossesse, :date_accouchement_prevu, :evolutions, :date_naissance, :date_recueil_evol

  def produits
    @produits = params[:produit_id] ? Produit.where(id: params[:produit_id]) : Produit.search_by_name(params[:q])
    respond_to do |format|
      format.json { render :json => @produits.map(&:name_and_id) }
    end
  end

  def indications
    @indications = params[:indication_id] ? Indication.where(id: params[:indication_id]) : Indication.search_by_name(params[:q])
    respond_to do |format|
      format.json { render :json => @indications.map(&:name_and_id) }
    end
  end

  def index
  end

  def show
  end

  def new
    @dossier = Dossier.new(code: params[:code], centre_id: current_user.centre_id)
  end

  def create
    @dossier = Dossier.new(dossier_params)
    if @dossier.save
      redirect_on_success
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @dossier.update(dossier_params)
      redirect_on_success
    else
      render :edit
    end
  end

  def destroy
    @dossier.destroy
    redirect_with_flash(@dossier, dossiers_path)
  end

  private

  def set_centre
    @centre = current_user.centre
  end

  def set_dossier
    @dossier = Dossier.find_by_code(params[:id])
  end

  def decorated_dossier
    @dossier = DossierDecorator.find(params[:id])
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

  def redirect_on_success
    if params[:_continue]
      redirect_with_flash @dossier, edit_dossier_path(@dossier)
    elsif params[:_add_another]
      redirect_with_flash @dossier, new_dossier_path
    else
      redirect_with_flash @dossier
    end
  end

  def dossier_params
    params.require(:dossier).permit(:date_appel, :centre_id, :user_id, :code, :correspondant_id, :a_relancer, :relance_counter, :correspondant_nom, :categoriesp_id,
      :motif_id, :modaccouch, :date_dernieres_regles, :date_reelle_accouchement, :date_accouchement_prevu, :date_debut_grossesse, :date_recueil_evol, :name, :prenom, :age, :antecedents_perso, :antecedents_fam, :ass_med_proc, :expo_terato, :tabac, :alcool, :fcs, :geu, :miu, :ivg, :img, :nai, :grsant, :age_grossesse, :terme, :path_mat, :comm_antecedents_perso, :comm_antecedents_fam, :comm_evol, :comm_expo, :commentaire, :toxiques, :date_naissance, :poids, :taille, :folique, :patho1t, :evolution, :imc,
      expositions_attributes: [:id, :expo_type_id, :expo_nature_id, :produit_id, :indication_id, :voie_id, :dose, :de, :de_date, :a, :a_date, :duree, :de2, :de2_date, :a2, :a2_date, :duree2, :expo_terme_id], bebes_attributes: [:id, :age, :sexe, :poids, :taille, :pc, :apgar1, :apgar5, :malformation, :pathologie, :malformation_tokens, :pathologie_tokens])
  end
end
