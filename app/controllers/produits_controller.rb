class ProduitsController < ApplicationController
  respond_to :json
  load_and_authorize_resource

  def index
    @produits = params[:produit_id] ? Produit.where(id: params[:produit_id]) : Produit.search_by_name(params[:q])
    respond_with @produits.map(&:name_and_id)
  end
end
