class RemoveIndexFromRelances < ActiveRecord::Migration
  def change
    remove_index :relances, :dossier_id
  end
end
