class CreateClassifications < ActiveRecord::Migration
  def change
    create_table :classifications do |t|
      t.belongs_to :produit, index: true
      t.belongs_to :atc, index: true

      t.timestamps
    end
  end
end
