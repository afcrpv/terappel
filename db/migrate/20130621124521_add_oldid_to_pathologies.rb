class AddOldidToPathologies < ActiveRecord::Migration
  def change
    add_column :pathologies, :oldid, :integer
  end
end
