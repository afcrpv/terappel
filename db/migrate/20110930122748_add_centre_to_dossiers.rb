class AddCentreToDossiers < ActiveRecord::Migration
  def change
    add_column :dossiers, :centre_id, :integer
  end
end
