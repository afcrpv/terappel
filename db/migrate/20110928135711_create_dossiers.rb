class CreateDossiers < ActiveRecord::Migration
  def change
    create_table :dossiers do |t|
      t.date :date_appel
      t.string :name
      t.integer :user_id

      t.timestamps
    end
  end
end
