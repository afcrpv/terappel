class AddBebesCountToDossiers < ActiveRecord::Migration
  def up
    add_column :dossiers, :bebes_count, :integer, default: 0

    Dossier.reset_column_information
    Dossier.all.each do |d|
      Dossier.update_counters d.id, bebes_count: d.bebes.length
    end
  end

  def down
    remove_column :dossiers, :bebes_count
  end
end
