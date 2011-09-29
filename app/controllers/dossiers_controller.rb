class DossiersController < ApplicationController

  def index
  end
  
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

  def edit
    @dossier = Dossier.find(params[:id])
  end

  def update
    @dossier = Dossier.find(params[:id])
    if @dossier.update_attributes(params[:dossier])
      redirect_with_flash(@dossier)
    else
      render :edit
    end
  end

  def destroy
    @dossier = Dossier.find(params[:id])
    if @dossier.destroy
      redirect_to dossiers_path, :notice => t("flash.destroy", :resource => "Dossier")
    end
  end
end
