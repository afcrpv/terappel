class AddGrsantToDossiers < ActiveRecord::Migration
  def change
    add_column :dossiers, :grsant, :integer
  end
end
