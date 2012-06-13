class AddVoieToExpositions < ActiveRecord::Migration
  def change
    add_column :expositions, :voie_id, :integer
  end
end
