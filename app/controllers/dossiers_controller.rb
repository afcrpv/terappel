class DossiersController < ApplicationController
  before_filter :find_centre
  before_filter :find_dossier, :only => :show
  load_and_authorize_resource :centre
  load_and_authorize_resource :dossier, :through => :centre

  def show
  end

  def new
  end

  def create
    if @dossier.save
      redirect_with_flash([@centre, @dossier])
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @dossier.update_attributes(params[:dossier])
      redirect_with_flash([@centre, @dossier])
    else
      render :edit
    end
  end

  def destroy
    if @dossier.destroy
      redirect_with_flash([@centre, @dossier], centre_path(@centre))
    end
  end

  private

  def find_centre
    @centre = current_user.centre
  end

  def find_dossier
    @dossier = DossierDecorator.find(params[:id])
  end
end
