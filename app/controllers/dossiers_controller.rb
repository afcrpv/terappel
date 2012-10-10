#encoding: utf-8
class DossiersController < AuthorizedController
  autocomplete :produit, :name, full: true, limit: 20
  autocomplete :indication, :name, full: true, limit: 20
  before_filter :find_centre
  before_filter :decorated_dossier, :only => :show
  load_and_authorize_resource :dossier

  helper_method :date_appel, :date_reelle_accouchement, :date_dernieres_regles, :date_debut_grossesse, :date_accouchement_prevu, :evolutions, :date_naissance, :date_recueil_evol

  def produits
    @produits = Produit.where("LOWER(name) like ?", "%#{params[:q]}%")
    respond_to do |format|
      format.json { render :json => @produits.map(&:name_and_id) }
    end
  end

  def indications
    @indications = Indication.where("LOWER(name) like ?", "%#{params[:q]}%")
    respond_to do |format|
      format.json { render :json => @indications.map(&:name_and_id) }
    end
  end

  def autocomplete_correspondant_fullname
    term = params[:term]
    if term && term.present?
      items = Correspondant.where(centre_id: @centre.id).
        where("LOWER(nom) like ?", term.downcase + "%").limit(20).order(:nom)
    else
      items = {}
    end
    render json: json_for_autocomplete(items, :fullname)
  end

  def index
    @dossiers = DossierDecorator.decorate(@dossiers)
  end

  def show
    @dossier = DossierDecorator.find(@dossier.id)
  end

  def new
    @dossier = Dossier.new(:code => params[:code])
  end

  def create
    @dossier.centre_id = @centre.id
    @dossier.user_id = current_user.id
    if @dossier.save
      redirect_on_success
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @dossier.update_attributes(params[:dossier])
      redirect_on_success
    else
      render :edit
    end
  end

  def destroy
    if @dossier.destroy
      redirect_with_flash(@dossier, dossiers_path)
    end
  end

  private

  def find_centre
    @centre = current_user.centre
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
end
