class AddLocalToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :local, :boolean
  end
end
