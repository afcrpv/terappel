class AddCentreToUsers < ActiveRecord::Migration
  def change
    add_column :users, :centre_id, :integer
  end
end
