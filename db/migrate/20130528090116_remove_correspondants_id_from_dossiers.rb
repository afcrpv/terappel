class RemoveCorrespondantsIdFromDossiers < ActiveRecord::Migration
  def change
    remove_column :dossiers, :demandeur_id, :integer
    remove_column :dossiers, :relance_id, :integer
  end
end
