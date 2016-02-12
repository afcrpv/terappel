class AddLibelleToEvolutions < ActiveRecord::Migration
  def change
    add_column :evolutions, :libelle, :string
  end
end
