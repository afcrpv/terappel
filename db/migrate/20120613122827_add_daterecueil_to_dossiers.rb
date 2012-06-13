class AddDaterecueilToDossiers < ActiveRecord::Migration
  def change
    add_column :dossiers, :date_recueil_evol, :date
  end
end
