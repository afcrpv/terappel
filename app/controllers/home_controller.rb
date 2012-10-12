class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def dossiers
    @dossiers = Dossier.where("LOWER(code) like ?", "%#{params[:q]}%")
    respond_to do |format|
      format.json { render json: @dossiers.map(&:code_and_id) }
    end
  end

  def try_new_dossier
    @code = params[:code].upcase
  end
end
