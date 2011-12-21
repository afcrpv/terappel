class AddCodetermepereToMalformations < ActiveRecord::Migration
  def change
    add_column :malformations, :codetermepere, :integer
  end
end
