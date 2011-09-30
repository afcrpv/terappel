class CreateCentres < ActiveRecord::Migration
  def change
    create_table :centres do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
  end
end
