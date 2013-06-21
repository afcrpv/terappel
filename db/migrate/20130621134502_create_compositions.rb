class CreateCompositions < ActiveRecord::Migration
  def change
    create_table :compositions do |t|
      t.belongs_to :produit, index: true
      t.belongs_to :dci, index: true

      t.timestamps
    end
  end
end
