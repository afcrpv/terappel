class CorrespondantsController < AuthorizedController
  respond_to :html, :js
  before_filter :find_centre
  load_and_authorize_resource :correspondant

  def show
  end

  def new
  end

  def create
    flash[:notice] = "Correspondant created" if @correspondant.save
    respond_with @correspondant, layout: !request.xhr?
  end

  def edit
  end

  private

  def find_centre
    @centre = current_user.centre
  end
end
