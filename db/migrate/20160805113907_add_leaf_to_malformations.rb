class AddLeafToMalformations < ActiveRecord::Migration
  def change
    add_column :malformations, :leaf, :boolean, default: false
  end
end
