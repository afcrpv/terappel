class CreateQualites < ActiveRecord::Migration
  def change
    create_table :qualites do |t|
      t.integer :oldid
      t.string :name

      t.timestamps
    end
  end
end
