class CreateCategoriesps < ActiveRecord::Migration
  def change
    create_table :categoriesps do |t|
      t.string :name
      t.integer :oldid

      t.timestamps
    end
  end
end
