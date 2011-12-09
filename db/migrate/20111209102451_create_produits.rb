class CreateProduits < ActiveRecord::Migration
  def change
    create_table :produits do |t|
      t.string :name

      t.timestamps
    end
  end
end
