class AddCentreToCorrespondant < ActiveRecord::Migration
  def change
    add_column :correspondants, :centre_id, :integer
  end
end
