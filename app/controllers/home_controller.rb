class HomeController < ApplicationController
  before_filter :authenticate_user!
  autocomplete :dossier, :code, :full => true

  def index
    if params[:dossier_code]
      @dossier = Dossier.find(params[:dossier_code]) rescue nil
      if @dossier
        redirect_to dossier_path(@dossier)
      else
        redirect_to new_dossier_path(:code => params[:dossier_code])
      end
    end
  end

end
