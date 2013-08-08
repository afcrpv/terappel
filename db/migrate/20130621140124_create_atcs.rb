class CreateAtcs < ActiveRecord::Migration
  def change
    create_table :atcs do |t|
      t.string :libelle
      t.string :libabr
      t.integer :level
      t.string :ancestry
      t.integer :parent_id
      t.integer :codetermepere
      t.integer :codeterme
      t.integer :oldid

      t.timestamps
    end
    add_index :atcs, :ancestry
  end
end
