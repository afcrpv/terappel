class SearchesController < ApplicationController
  respond_to :html
  respond_to :csv, only: :show

  load_and_authorize_resource :search

  def new
    @search = Dossier.search(params[:q])
    @search.build_grouping unless @search.groupings.any?
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
    @search = Dossier.search(Search.find(params[:id]).q)
    @search.build_grouping unless @search.groupings.any?
  end

  def update
    flash[:notice] = nil
    @search.q = params[:search]
    @search.update(search_params)
    respond_with @search, location: @search
  end

  private

  def search_params
    params.require(:search).permit(:g)#:local, :centre_id, :min_date_appel, :max_date_appel, :motif_id, :expo_nature_id, :expo_type_id, :indication_id, :expo_terme_id, :evolution, :malformation, :pathologie, :produit_tokens, :dci_tokens)
  end

  def interpolation_options
    {resource_name: "Recherche"}
  end
end
