class CreateExpositions < ActiveRecord::Migration
  def change
    create_table :expositions do |t|
      t.integer :produit_id                       # nproduit
      t.integer :dossier_id
      t.string :nappelsaisi
      t.integer :expo_type_id                     # ntype
      t.integer :indication_id                    # nindication
      t.integer :expo_terme_id                    # nterme
      t.integer :expo_nature_id                   # nnatexpo
      t.integer :numord                           # c'est quoi?
      t.integer :duree
      t.integer :duree2
      t.string :dose
      t.integer :de
      t.integer :a
      t.integer :de2
      t.integer :a2
      t.string :medpres

      t.timestamps
    end
  end
end
