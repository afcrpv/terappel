class SearchesController < ApplicationController
  load_and_authorize_resource :search

  helper_method :min_date_appel, :max_date_appel

  def new
    @search = Search.new(centre_id: current_user.centre_id)
  end

  def create
    if @search.save
      redirect_to @search
    else
      render :new
    end
  end

  def show
    @filename = "Export_terappel_" + I18n.l(Date.today).gsub("/","_") + ".csv"
    @csv_options = {col_sep: ";"}
    @search = SearchDecorator.find(params[:id])
    dossiers = @search.find_dossiers
    @dossiers = DossierDecorator.decorate(dossiers)
    @dossiers_for_csv = DossierDecorator.decorate dossiers
    respond_to do |format|
      format.html
      format.csv
    end
  end

  def edit
  end

  def update
    if @search.update_attributes(params[:search])
      redirect_to @search
    else
      render :edit
    end
  end

  private

  def min_date_appel
    @min_date_appel = params[:id] && @search.min_date_appel ? l(@search.min_date_appel) : l(Dossier.minimum(:date_appel))
  end

  def max_date_appel
    @max_date_appel = params[:id] && @search.max_date_appel ? l(@search.max_date_appel) : l(Dossier.maximum(:date_appel))
  end
end
