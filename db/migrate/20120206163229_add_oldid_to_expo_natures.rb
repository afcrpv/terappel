class AddOldidToExpoNatures < ActiveRecord::Migration
  def change
    add_column :expo_natures, :oldid, :integer
  end
end
