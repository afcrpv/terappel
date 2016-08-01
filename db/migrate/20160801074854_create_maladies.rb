class CreateMaladies < ActiveRecord::Migration
  def change
    create_table :maladies do |t|
      t.string :code
      t.string :pere
      t.string :libelle
      t.string :ancestry
      t.integer :parent_id

      t.timestamps null: false
    end
  end
end
