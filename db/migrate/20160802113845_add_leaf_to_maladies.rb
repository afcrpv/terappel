class AddLeafToMaladies < ActiveRecord::Migration
  def change
    add_column :maladies, :leaf, :boolean
  end
end
