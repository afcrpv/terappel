class ChangeCorrespondantKeysInDossiers < ActiveRecord::Migration
  def up
    rename_column :dossiers, :correspondant_id, :demandeur_id
    add_column :dossiers, :relance_id, :integer
    add_index :dossiers, :relance_id
  end

  def down
    rename_column :dossiers, :demandeur_id, :correspondant_id
    remove_column :dossiers, :relance_id
    remove_index :dossiers, :relance_id
  end
end
