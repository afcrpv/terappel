class CreateExpoTypes < ActiveRecord::Migration
  def change
    create_table :expo_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
