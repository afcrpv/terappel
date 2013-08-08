class AddDciIdToSearches < ActiveRecord::Migration
  def change
    add_column :searches, :dci_id, :integer
  end
end
