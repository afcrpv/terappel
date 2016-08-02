class AddNameToMaladies < ActiveRecord::Migration
  def change
    add_column :maladies, :name, :string

    add_index :maladies, :name
  end
end
