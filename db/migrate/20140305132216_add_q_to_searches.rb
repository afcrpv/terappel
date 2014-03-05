class AddQToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :q, :string, limit: 4096
  end
end
