class CreateProduitsSearches < ActiveRecord::Migration
  def change
    create_table :produits_searches, id: false do |t|
      t.integer :produit_id
      t.integer :search_id
    end
  end
end
