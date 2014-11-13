module Admin
  class ProduitsController < ApplicationController
    load_and_authorize_resource
    respond_to :html

    def index
    end

    def new
      @produit = Produit.new
      respond_with @produit
    end

    def create
      @produit = Produit.create(produit_params)
      respond_with @produit, location: admin_produits_url
    end

    def edit
      respond_with @produit
    end

    def update
      @produit.update(produit_params)
      respond_with @produit, location: admin_produits_url
    end

    private
    # Never trust parameters from the scary internet, only allow the white list through.
    def produit_params
      params.require(:produit).permit(:name)
    end
  end
end
