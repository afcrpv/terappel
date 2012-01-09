class RenameMalformaPathoFieldsInBebes < ActiveRecord::Migration
  def up
    change_table :bebes do |t|
      t.rename :malforma, :malformation
      t.rename :patho, :pathologie
    end
  end

  def down
    change_table :bebes do |t|
      t.rename :malformation, :malforma
      t.rename :pathologie, :patho
    end
  end
end
