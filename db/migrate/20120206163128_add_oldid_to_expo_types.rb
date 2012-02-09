class AddOldidToExpoTypes < ActiveRecord::Migration
  def change
    add_column :expo_types, :oldid, :integer

  end
end
