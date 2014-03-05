class AddDistinctToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :distinct, :integer, default: 1
  end
end
