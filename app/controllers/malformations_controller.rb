class MalformationsController < ApplicationController
  def index
    @malformations = Malformation.where("LOWER(libelle) like ?", "%#{params[:q]}%").limit(10)
    respond_to do |format|
      format.json { render :json => @malformations }
    end
  end
end
