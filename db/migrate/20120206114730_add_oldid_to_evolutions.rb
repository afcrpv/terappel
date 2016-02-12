class AddOldidToEvolutions < ActiveRecord::Migration
  def change
    add_column :evolutions, :oldid, :integer
  end
end
