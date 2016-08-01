class AddIndexToMaladies < ActiveRecord::Migration
  def change
    add_index :maladies, :libelle, unique: true
    add_index :maladies, :ancestry
  end
end
