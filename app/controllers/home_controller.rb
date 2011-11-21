class HomeController < ApplicationController
  before_filter :authenticate_user!
  autocomplete :dossier, :code, :full => true

  def index
    if params[:dossier_code]
      @dossier = Dossier.find(params[:dossier_code])
      redirect_to dossier_path(@dossier)
    end
  end

end
