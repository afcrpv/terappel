class AddExpositionsCounts < ActiveRecord::Migration
  def up
    add_column :dossiers, :expositions_count, :integer, default: 0
    add_column :produits, :expositions_count, :integer, default: 0
    Dossier.reset_column_information
    Dossier.all.each do |dossier|
      Dossier.update_counters dossier.id, expositions_count: dossier.expositions.length
    end
    Produit.reset_column_information
    Produit.all.each do |produit|
      Produit.update_counters produit.id, expositions_count: produit.expositions.length
    end
  end

  def down
    remove_column :dossiers, :expositions_count
    remove_column :produits, :expositions_count
  end
end
