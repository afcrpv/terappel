class AddPrenomToCorrespondants < ActiveRecord::Migration
  def change
    add_column :correspondants, :prenom, :string
  end
end
