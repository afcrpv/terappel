class AddImgToDossier < ActiveRecord::Migration
  def change
    add_column :dossiers, :img, :integer
  end
end
