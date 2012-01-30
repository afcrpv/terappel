class CreateFormules < ActiveRecord::Migration
  def change
    create_table :formules do |t|
      t.integer :oldid
      t.string :name

      t.timestamps
    end
  end
end
