class AddPoidsandtailleToDossiers < ActiveRecord::Migration
  def change
    add_column :dossiers, :poids, :integer
    add_column :dossiers, :taille, :integer
  end
end
