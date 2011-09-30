class DossiersController < ApplicationController
  load_and_authorize_resource :centre
  load_and_authorize_resource :dossier, :through => :centre

  def index
  end

  def show
  end

  def new
    @centre = current_user.centre
    @dossier = @centre.dossiers.build
  end

  def create
    @centre = current_user.centre
    @dossier = @centre.dossiers.build(params[:dossier])
    if @dossier.save
      redirect_with_flash(@dossier)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @dossier.update_attributes(params[:dossier])
      redirect_with_flash(@dossier)
    else
      render :edit
    end
  end

  def destroy
    if @dossier.destroy
      redirect_to dossiers_path, :notice => t("flash.destroy", :resource => "Dossier")
    end
  end
end
