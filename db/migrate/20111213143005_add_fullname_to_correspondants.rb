class AddFullnameToCorrespondants < ActiveRecord::Migration
  def change
    add_column :correspondants, :fullname, :string
  end
end
