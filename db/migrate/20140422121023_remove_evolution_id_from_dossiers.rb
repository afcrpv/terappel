class RemoveEvolutionIdFromDossiers < ActiveRecord::Migration
  def up
    remove_column :dossiers, :evolution_id
  end

  def down
    add_column :dossiers, :evolution_id, :integer
  end
end
