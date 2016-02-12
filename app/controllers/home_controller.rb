class HomeController < ApplicationController
  def index
    authorize! :index, :home
  end

  def dossiers
    authorize! :dossiers, :home
    @dossiers = Dossier.where('LOWER(code) like ?', "%#{params[:q]}%")
    respond_to do |format|
      format.json { render json: @dossiers.map(&:code_and_id) }
    end
  end

  def try_new_dossier
    authorize! :try_new_dossier, :home
    @code = params[:code].upcase
  end
end
