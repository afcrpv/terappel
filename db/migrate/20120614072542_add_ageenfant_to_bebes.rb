class AddAgeenfantToBebes < ActiveRecord::Migration
  def change
    add_column :bebes, :age, :integer
  end
end
