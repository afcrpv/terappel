class AddImcToDossiers < ActiveRecord::Migration
  def change
    add_column :dossiers, :imc, :integer
  end
end
