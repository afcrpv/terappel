class AddPathologiesIndices < ActiveRecord::Migration
  def change
    add_index :pathologies, :ancestry
  end
end
