class ChangeARelancerColumnTypeInDossiers < ActiveRecord::Migration
  def up
    change_column :dossiers, :a_relancer, :string
  end

  def down
    change_column :dossiers, :a_relancer, :integer
  end
end
