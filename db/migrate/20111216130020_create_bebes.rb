class CreateBebes < ActiveRecord::Migration
  def change
    create_table :bebes do |t|
      t.integer :dossier_id
      t.string :malforma
      t.string :patho
      t.string :sexe
      t.integer :poids
      t.integer :apgar1
      t.integer :apgar5
      t.integer :pc
      t.integer :taille

      t.timestamps
    end
  end
end
