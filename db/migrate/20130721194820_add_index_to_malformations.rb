class AddIndexToMalformations < ActiveRecord::Migration
  def change
    add_index :malformations, :libelle, unique: true
  end
end
