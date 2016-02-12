class CreatePathologiesBebes < ActiveRecord::Migration
  def change
    create_table :bebes_pathologies, id: false do |t|
      t.integer :bebe_id
      t.integer :pathologie_id
    end
  end
end
