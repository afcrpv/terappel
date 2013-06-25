class AddOldCorrespondantsIdsToDossiers < ActiveRecord::Migration
  def change
    add_column :dossiers, :nident, :integer
    add_column :dossiers, :nrelance, :integer
  end
end
