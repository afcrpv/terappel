class CreateSpecialites < ActiveRecord::Migration
  def change
    create_table :specialites do |t|
      t.integer :oldid
      t.string :name

      t.timestamps
    end
  end
end
