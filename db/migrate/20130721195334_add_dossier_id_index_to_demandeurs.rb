class AddDossierIdIndexToDemandeurs < ActiveRecord::Migration
  def change
    add_index :demandeurs, :dossier_id, unique: true
  end
end
