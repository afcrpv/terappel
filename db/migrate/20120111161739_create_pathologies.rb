class CreatePathologies < ActiveRecord::Migration
  def change
    create_table :pathologies do |t|
      t.string :libelle
      t.string :libabr
      t.integer :level
      t.string :ancestry
      t.integer :parent_id
      t.integer :codetermepere
      t.integer :codeterme

      t.timestamps
    end
  end
end
