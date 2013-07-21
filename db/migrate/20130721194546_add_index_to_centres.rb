class AddIndexToCentres < ActiveRecord::Migration
  def change
    add_index :centres, :name, unique: true
  end
end
