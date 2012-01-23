class PathologiesController < ApplicationController
  def index
    @pathologies = Pathologie.where("LOWER(libelle) like ?", "%#{params[:q]}%").limit(10)
    respond_to do |format|
      format.json { render :json => @pathologies }
    end
  end
end
