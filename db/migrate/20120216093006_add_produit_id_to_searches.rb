class AddProduitIdToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :produit_id, :integer
  end
end
