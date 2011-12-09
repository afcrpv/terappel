class CreateExpoNatures < ActiveRecord::Migration
  def change
    create_table :expo_natures do |t|
      t.string :name

      t.timestamps
    end
  end
end
