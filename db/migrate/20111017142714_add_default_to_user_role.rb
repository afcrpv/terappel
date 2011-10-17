class AddDefaultToUserRole < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.change_default(:role, 'centre_user')
    end
  end
end
