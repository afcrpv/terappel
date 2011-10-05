class DossiersController < ApplicationController
  before_filter :find_centre
  load_and_authorize_resource :centre
  load_and_authorize_resource :dossier, :through => :centre

  def index
  end

  def show
  end

  def new
  end

  def create
    @dossier = @centre.dossiers.build(params[:dossier])
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
      redirect_with_flash([@centre, @dossier], centre_dossiers_path(@centre))
    end
  end

  private

  def find_centre
    @centre = current_user.centre
  end
end
