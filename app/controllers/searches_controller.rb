class SearchesController < ApplicationController
  respond_to :html
  respond_to :csv, only: :show

  load_and_authorize_resource :search

  helper_method :min_date_appel, :max_date_appel

  def new
    @search = Search.new(centre_id: current_user.centre_id)
    respond_with @search
  end

  def create
    @search = Search.new(search_params)
    @search.q = params[:search]
    @search.save!
    respond_with @search, location: @search
  end

  def show
    @filename = "Export_terappel_" + I18n.l(Date.today).gsub("/","_") + ".csv"
    ransack = Dossier.includes(:produits, :bebes, :motif).search(@search.q)
    @dossiers = @search.distinct.zero? ? ransack.result : ransack.result(distinct: true)
    @decorated_dossiers = @dossiers.decorate
    @dossiers_count = @dossiers.count

    respond_with @search do |format|
      format.html { render }
      format.csv { send_data @decorated_dossiers.to_csv(col_sep: ";").encode('iso-8859-1', 'utf-8'), filename: @filename }
    end
  end

  def edit
    respond_with @search
  end

  def update
    flash[:notice] = nil
    @search.update(search_params)
    respond_with @search, location: @search
  end

  private

  def search_params
    params.require(:search).permit(:local, :centre_id, :min_date_appel, :max_date_appel, :motif_id, :expo_nature_id, :expo_type_id, :indication_id, :expo_terme_id, :evolution, :malformation, :pathologie, :produit_tokens, :dci_tokens)
  end

  def min_date_appel
    @min_date_appel = params[:id] && @search.min_date_appel ? l(@search.min_date_appel) : l(Dossier.minimum(:date_appel))
  end

  def max_date_appel
    @max_date_appel = params[:id] && @search.max_date_appel ? l(@search.max_date_appel) : l(Dossier.maximum(:date_appel))
  end

  def interpolation_options
    {resource_name: "Recherche"}
  end
end
