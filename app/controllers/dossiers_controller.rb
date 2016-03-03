class DossiersController < ApplicationController
  # TODO: cleanup dossiers controller

  before_action :set_centre
  before_action :set_dossier, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  respond_to :html
  respond_to :js, only: :index
  respond_to :pdf, only: :show

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    redirect_to dossiers_url, alert: "Vous ne pouvez pas modifier un dossier n'appartenant pas à votre CRPV !" # exception.message
  end

  helper_method :min_date_appel, :max_date_appel

  def indications
    @indications = params[:indication_id] ? Indication.where(id: params[:indication_id]) : Indication.search_by_name(params[:q])
    respond_with @indications.map(&:name_and_id)
  end

  def dcis
    @dcis = params[:dci_id] ? Dci.where(id: params[:dci_id]) : Dci.search_by_name(params[:q])
    respond_with @dcis.map(&:name_and_id)
  end

  def index
    @grid = DossiersGrid.new(dossiers_grid_params
      .merge(current_user: current_user))
    respond_with @grid do |format|
      format.html do
        @grid.scope { |scope| scope.where(centre_id: current_user.centre_id).page(params[:page]) }
      end
      format.csv do
        send_data @grid.to_csv,
                  type: 'text/csv',
                  disposition: 'inline',
                  filename: "dossiers-#{Time.now}.csv"
      end
    end
  end

  def show
    @decorated_dossier = @dossier.decorate
    respond_with @dossier do |format|
      format.html { render layout: false }
      format.pdf do
        pdf = DossierPdf.new(@dossier, @decorated_dossier, view_context)
        send_data pdf.render, filename: "dossier_#{@dossier.code}.pdf",
                              type: 'application/pdf',
                              disposition: 'inline'
      end
    end
  end

  def new
    @dossier = Dossier.new(code: params[:code], centre_id: current_user.centre_id)
    @dossier.build_demandeur
    @dossier.build_relance

    respond_with @dossier
  end

  def create
    @dossier = Dossier.create(dossier_params)
    if params[:_continue]
      location = edit_dossier_path(@dossier, current_tab: params[:dossier][:current_tab])
    elsif params[:_preview]
      location = edit_dossier_path(@dossier, current_tab: params[:dossier][:current_tab], show_preview: 'true')
    elsif params[:_add_another]
      location = new_dossier_path
    else
      location = dossiers_url
    end
    respond_with @dossier, location: location
  end

  def edit
    @dossier.build_demandeur unless @dossier.demandeur
    @dossier.build_relance unless @dossier.relance
    respond_with @dossier
  end

  def update
    if params[:_continue]
      location = edit_dossier_path(@dossier, current_tab: params[:dossier][:current_tab])
    elsif params[:_preview]
      location = edit_dossier_path(@dossier, current_tab: params[:dossier][:current_tab], show_preview: 'true')
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

  # def interpolation_options
  # { resource_name: "Dossier #{@dossier.code}" }
  # end

  def set_centre
    @centre = current_user.centre
  end

  def set_dossier
    @dossier = Dossier.includes(expositions: [:produit, :indication]).friendly.find(params[:id])
  end

  def date_appel
    @date_appel ||= params[:id] && @dossier.date_appel? ? l(@dossier.date_appel) : ''
  end

  def date_dernieres_regles
    @date_dernieres_regles ||= params[:id] && @dossier.date_dernieres_regles? ? l(@dossier.date_dernieres_regles) : ''
  end

  def date_debut_grossesse
    @date_debut_grossesse ||= params[:id] && @dossier.date_debut_grossesse? ? l(@dossier.date_debut_grossesse) : ''
  end

  def date_reelle_accouchement
    @date_reelle_accouchement ||= params[:id] && @dossier.date_reelle_accouchement? ? l(@dossier.date_reelle_accouchement) : ''
  end

  def date_accouchement_prevu
    @date_accouchement_prevu ||= params[:id] && @dossier.date_accouchement_prevu? ? l(@dossier.date_accouchement_prevu) : ''
  end

  def date_naissance
    @date_naissance ||= params[:id] && @dossier.date_naissance? ? l(@dossier.date_naissance) : ''
  end

  def date_recueil_evol
    @date_recueil_evol ||= params[:id] && @dossier.date_recueil_evol? ? l(@dossier.date_recueil_evol) : ''
  end

  def evolutions
    @evolutions = Evolution.all
  end

  def dossier_params
    params.require(:dossier).permit(:date_appel, :centre_id, :user_id, :current_tab, :code, :a_relancer, :relance_counter, :categoriesp_id,
                                    :motif_id, :modaccouch, :date_dernieres_regles, :date_reelle_accouchement, :date_accouchement_prevu, :date_debut_grossesse, :date_recueil_evol, :name, :prenom, :age, :antecedents_perso, :antecedents_fam, :ass_med_proc, :expo_terato, :tabac, :alcool, :fcs, :geu, :miu, :ivg, :img, :nai, :grsant, :age_grossesse, :terme, :path_mat, :comm_antecedents_perso, :comm_antecedents_fam, :comm_evol, :comm_expo, :commentaire, :toxiques, :date_naissance, :poids, :taille, :folique, :patho1t, :evolution, :imc,
                                    demandeur_attributes: [:correspondant_id],
                                    relance_attributes: [:correspondant_id],
                                    expositions_attributes: [:id, :expo_type_id, :expo_nature_id, :produit_id, :indication_id, :voie_id, :dose, :de, :de_date, :a, :a_date, :duree, :de2, :de2_date, :a2, :a2_date, :duree2, :expo_terme_id, :_destroy], bebes_attributes: [:id, :age, :sexe, :poids, :taille, :pc, :apgar1, :apgar5, :malformation, :pathology, { malformation_ids: [], pathology_ids: [] }, :_destroy])
  end

  def min_date_appel
    @min_date_appel = params[:id] && @q.min_date_appel ? l(@q.min_date_appel) : l(Dossier.minimum(:date_appel))
  end

  def max_date_appel
    @max_date_appel = params[:id] && @q.max_date_appel ? l(@q.max_date_appel) : l(Dossier.maximum(:date_appel))
  end

  def interpolation_options
    { resource_name: "Dossier #{@dossier.code}" }
  end

  def dossiers_grid_params
    @dossiers_grid_params = params[:dossiers_grid] || {}
  end
end
