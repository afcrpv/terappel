class CreateBebesMalformations < ActiveRecord::Migration
  def up
    drop_table :bebes_malformations
    create_table :bebes_malformations do |t|
      t.belongs_to :bebe, index: true, foreign_key: true
      t.belongs_to :malformation, index: true, foreign_key: true

      t.timestamps null: false
    end
  end

  def down
    drop_table :bebes_malformations
    create_table :bebes_malformations, id: false do |t|
      t.integer :bebe_id
      t.integer :malformation_id
    end
  end
end
