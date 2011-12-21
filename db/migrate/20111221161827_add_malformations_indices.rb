class AddMalformationsIndices < ActiveRecord::Migration
  def change
    add_index :malformations, :ancestry
  end
end
