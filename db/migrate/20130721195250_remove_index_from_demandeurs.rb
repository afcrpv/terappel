class RemoveIndexFromDemandeurs < ActiveRecord::Migration
  def change
    remove_index :demandeurs, :dossier_id
  end
end
