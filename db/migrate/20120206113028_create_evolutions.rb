class CreateEvolutions < ActiveRecord::Migration
  def change
    create_table :evolutions do |t|
      t.string :name

      t.timestamps
    end
  end
end
