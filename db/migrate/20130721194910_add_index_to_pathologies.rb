class AddIndexToPathologies < ActiveRecord::Migration
  def change
    add_index :pathologies, :libelle, unique: true
  end
end
