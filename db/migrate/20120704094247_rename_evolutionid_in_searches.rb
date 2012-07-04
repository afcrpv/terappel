class RenameEvolutionidInSearches < ActiveRecord::Migration
  def change
    change_table :searches do |t|
      t.rename :evolution_id, :evolution
    end
  end
end
