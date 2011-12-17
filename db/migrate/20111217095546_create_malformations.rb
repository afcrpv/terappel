class CreateMalformations < ActiveRecord::Migration
  def change
    create_table :malformations do |t|
      t.string :libelle
      t.string :libabr
      t.integer :level
      t.string :ancestry
      t.integer :parent_id

      t.timestamps
    end
  end
end
