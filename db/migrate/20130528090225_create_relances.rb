class CreateRelances < ActiveRecord::Migration
  def change
    create_table :relances do |t|
      t.belongs_to :dossier, index: true
      t.belongs_to :correspondant, index: true

      t.timestamps
    end
  end
end
