class CreateCorrespondants < ActiveRecord::Migration
  def change
    create_table :correspondants do |t|
      t.integer :specialite_id
      t.integer :qualite_id
      t.integer :formule_id
      t.string :nom
      t.text :adresse
      t.string :cp
      t.string :ville
      t.string :telephone
      t.string :fax
      t.string :poste
      t.string :email

      t.timestamps
    end

    fields = %w(specialite_id qualite_id nom cp ville)
    fields.each do |field|
      add_index :correspondants, field.to_sym
    end
  end
end
