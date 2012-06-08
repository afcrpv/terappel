class AddToxiquesToDossiers < ActiveRecord::Migration
  def change
    add_column :dossiers, :toxiques, :integer
  end
end
