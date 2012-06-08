class AddDatenaissanceToDossiers < ActiveRecord::Migration
  def change
    add_column :dossiers, :date_naissance, :date
  end
end
