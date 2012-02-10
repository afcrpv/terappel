#encoding: utf-8
class DossiersController < AuthorizedController
  autocomplete :produit, :name, full: true
  autocomplete :indication, :name, full: true
  before_filter :find_centre
  before_filter :decorated_dossier, :only => :show
  load_and_authorize_resource :dossier

  helper_method :date_appel, :date_reelle_accouchement, :date_dernieres_regles, :date_debut_grossesse, :date_accouchement_prevu, :evolutions

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
    @search = Dossier.search(params[:q])
    dossiers_ordered_unordered = @search.result.order(sort_column("date_appel", Dossier) + ' ' + sort_direction("desc"))
    @dossiers = DossierDecorator.decorate(dossiers_ordered_unordered.includes(:correspondant).page(params[:page]))
  end

  def show
  end

  def new
    @dossier = Dossier.new(:code => params[:code])
  end

  def create
    @dossier.centre_id = @centre.id
    @dossier.user_id = current_user.id
    if @dossier.save
      redirect_with_flash(@dossier, dossiers_path, :success, "Dossier##{@dossier.code} créé avec succès.")
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @dossier.update_attributes(params[:dossier])
      redirect_with_flash(@dossier, dossiers_path)
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

  def evolutions
    @evolutions = Evolution.all
  end
end
