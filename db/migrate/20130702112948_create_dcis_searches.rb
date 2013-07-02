class CreateDcisSearches < ActiveRecord::Migration
  def change
    create_table :dcis_searches, id: false do |t|
      t.integer :dci_id
      t.integer :search_id
    end
  end
end
