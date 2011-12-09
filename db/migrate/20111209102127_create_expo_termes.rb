class CreateExpoTermes < ActiveRecord::Migration
  def change
    create_table :expo_termes do |t|
      t.string :name

      t.timestamps
    end
  end
end
