class AddOldidToIndications < ActiveRecord::Migration
  def change
    add_column :indications, :oldid, :integer

  end
end
