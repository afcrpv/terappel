class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.date :min_date_appel
      t.integer :centre_id
      t.date :max_date_appel
      t.integer :motif_id
      t.integer :expo_nature_id
      t.integer :expo_type_id
      t.integer :indication_id
      t.integer :expo_terme_id
      t.integer :evolution_id
      t.string :malformation
      t.string :pathologie

      t.timestamps
    end
  end
end
