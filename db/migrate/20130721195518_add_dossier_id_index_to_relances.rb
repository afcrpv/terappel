class AddDossierIdIndexToRelances < ActiveRecord::Migration
  def change
    add_index :relances, :dossier_id, unique: true
  end
end
