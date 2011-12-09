class CreateIndications < ActiveRecord::Migration
  def change
    create_table :indications do |t|
      t.string :name

      t.timestamps
    end
  end
end
