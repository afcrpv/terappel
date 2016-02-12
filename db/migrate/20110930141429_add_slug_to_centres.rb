class AddSlugToCentres < ActiveRecord::Migration
  def change
    add_column :centres, :slug, :string

    add_index :centres, :slug, unique: true
  end
end
