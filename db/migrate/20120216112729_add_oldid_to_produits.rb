class AddOldidToProduits < ActiveRecord::Migration
  def change
    add_column :produits, :oldid, :integer
  end
end
