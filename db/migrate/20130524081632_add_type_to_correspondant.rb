class AddTypeToCorrespondant < ActiveRecord::Migration
  def change
    add_column :correspondants, :type, :string
  end
end
