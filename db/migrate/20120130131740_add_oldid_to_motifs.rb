class AddOldidToMotifs < ActiveRecord::Migration
  def change
    add_column :motifs, :oldid, :integer

  end
end
