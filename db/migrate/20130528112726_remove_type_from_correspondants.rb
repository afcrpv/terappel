class RemoveTypeFromCorrespondants < ActiveRecord::Migration
  def change
    remove_column :correspondants, :type, :string
  end
end
