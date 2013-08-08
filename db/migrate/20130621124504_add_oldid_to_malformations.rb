class AddOldidToMalformations < ActiveRecord::Migration
  def change
    add_column :malformations, :oldid, :integer
  end
end
