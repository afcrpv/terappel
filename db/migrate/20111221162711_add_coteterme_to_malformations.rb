class AddCotetermeToMalformations < ActiveRecord::Migration
  def change
    add_column :malformations, :codeterme, :integer
  end
end
