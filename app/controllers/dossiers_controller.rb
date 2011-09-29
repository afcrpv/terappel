class DossiersController < ApplicationController
  
  def show
    @dossier = Dossier.find(params[:id])
  end

  def new
    @dossier = Dossier.new
  end

  def create
    @dossier = Dossier.new(params[:dossier])
    if @dossier.save
      redirect_with_flash(@dossier)
    else
      render :new
    end
  end
end
