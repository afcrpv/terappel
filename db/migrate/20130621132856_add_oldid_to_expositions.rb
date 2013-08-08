class AddOldidToExpositions < ActiveRecord::Migration
  def change
    add_column :expositions, :oldid, :integer
  end
end
