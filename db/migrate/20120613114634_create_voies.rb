class CreateVoies < ActiveRecord::Migration
  def change
    create_table :voies do |t|
      t.string :name

      t.timestamps
    end
  end
end
