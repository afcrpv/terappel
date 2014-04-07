class AddExpositionsCountToIndications < ActiveRecord::Migration
  def up
    add_column :indications, :expositions_count, :integer, default: 0
    Indication.reset_column_information
    Indication.all.each do |indication|
      Indication.update_counters indication.id, expositions_count: indication.expositions.length
    end
  end

  def down
    remove_column :indications, :expositions_count
  end
end
