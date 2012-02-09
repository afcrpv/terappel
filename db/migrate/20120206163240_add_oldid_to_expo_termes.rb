class AddOldidToExpoTermes < ActiveRecord::Migration
  def change
    add_column :expo_termes, :oldid, :integer

  end
end
