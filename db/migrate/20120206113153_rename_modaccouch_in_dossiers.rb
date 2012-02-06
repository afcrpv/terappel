class RenameModaccouchInDossiers < ActiveRecord::Migration
  def change
    change_table :dossiers do |t|
      t.change :mod_accouch_id, :string
      t.rename :mod_accouch_id, :modaccouch
    end
  end
end
