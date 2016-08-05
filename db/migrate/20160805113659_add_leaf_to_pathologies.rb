class AddLeafToPathologies < ActiveRecord::Migration
  def change
    add_column :pathologies, :leaf, :boolean, default: false
  end
end
