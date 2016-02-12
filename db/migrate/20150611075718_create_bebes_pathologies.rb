class CreateBebesPathologies < ActiveRecord::Migration
  def up
    drop_table :bebes_pathologies
    create_table :bebes_pathologies do |t|
      t.belongs_to :bebe, index: true, foreign_key: true
      t.belongs_to :pathology, index: true, foreign_key: true

      t.timestamps null: false
    end
  end

  def down
    drop_table :bebes_pathologies
    create_table :bebes_pathologies, id: false do |t|
      t.integer :bebe_id
      t.integer :pathologie_id
    end
  end
end
