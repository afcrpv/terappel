class CreateMotifs < ActiveRecord::Migration
  def change
    create_table :motifs do |t|
      t.string :name

      t.timestamps
    end
  end
end
