class AddEvolutionToDossiers < ActiveRecord::Migration
  def change
    add_column :dossiers, :evolution, :integer
  end
end
