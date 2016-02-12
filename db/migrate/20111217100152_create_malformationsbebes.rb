class CreateMalformationsbebes < ActiveRecord::Migration
  def change
    create_table :bebes_malformations, id: false do |t|
      t.integer :bebe_id
      t.integer :malformation_id
    end
  end
end
