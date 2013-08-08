class CreateDcis < ActiveRecord::Migration
  def change
    create_table :dcis do |t|
      t.string :libelle
      t.integer :oldid

      t.timestamps
    end
    add_index :dcis, :libelle, unique: true
  end
end
