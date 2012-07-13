class AddDatesExpoToExpositions < ActiveRecord::Migration
  def change
    add_column :expositions, :de_date, :date
    add_column :expositions, :de2_date, :date
    add_column :expositions, :a_date, :date
    add_column :expositions, :a2_date, :date
  end
end
