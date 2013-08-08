class AddOldidToBebes < ActiveRecord::Migration
  def change
    add_column :bebes, :oldid, :integer
  end
end
