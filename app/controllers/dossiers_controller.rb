class DossiersController < AuthorizedController
  before_filter :find_centre
  before_filter :decorated_dossier, :only => :show
  load_and_authorize_resource :dossier

  def show
  end

  def new
    @dossier = Dossier.new(:centre_id => @centre.id, :user_id => current_user.id)
  end

  def create
    @dossier.centre_id = params[:dossier][:centre_id]
    @dossier.user_id = params[:dossier][:user_id]
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
      redirect_with_flash(@dossier)
    end
  end

  private

  def find_centre
    @centre = current_user.centre
  end

  def decorated_dossier
    @dossier = DossierDecorator.find(params[:id])
  end
end
