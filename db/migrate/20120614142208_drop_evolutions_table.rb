class DropEvolutionsTable < ActiveRecord::Migration
  def up
    drop_table :evolutions
  end

  def down
    create_table :evolutions do |t|
      t.string :name

      t.timestamps
    end
  end
end
