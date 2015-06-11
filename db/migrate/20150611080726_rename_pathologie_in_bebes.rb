class RenamePathologieInBebes < ActiveRecord::Migration
  def change
    rename_column :bebes, :pathologie, :pathology
  end
end
