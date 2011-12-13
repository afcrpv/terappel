class DossiersController < AuthorizedController
  autocomplete :correspondant, :fullname, :full => true
  before_filter :find_centre
  before_filter :decorated_dossier, :only => :show
  load_and_authorize_resource :dossier

  helper_method :date_appel

  def index
    @search = Dossier.search(params[:q])
    @dossiers = @search.result
  end

  def show
  end

  def new
    @dossier = Dossier.new(:centre_id => @centre.id, :user_id => current_user.id, :code => params[:code])
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
      redirect_with_flash(@dossier, dossiers_path)
    end
  end

  private

  def find_centre
    @centre = current_user.centre
  end

  def decorated_dossier
    @dossier = DossierDecorator.find(params[:id])
  end

  def date_appel
    @date_appel ||= params[:id] && @dossier.date_appel? ? l(@dossier.date_appel) : ""
  end
end
