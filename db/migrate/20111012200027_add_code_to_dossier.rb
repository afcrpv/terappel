class AddCodeToDossier < ActiveRecord::Migration
  def change
    add_column :dossiers, :code, :string
    add_index :dossiers, :code, unique: true
  end
end
