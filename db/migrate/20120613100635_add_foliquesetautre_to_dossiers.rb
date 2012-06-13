class AddFoliquesetautreToDossiers < ActiveRecord::Migration
  def change
    add_column :dossiers, :folique, :integer
    add_column :dossiers, :patho1t, :integer
  end
end
