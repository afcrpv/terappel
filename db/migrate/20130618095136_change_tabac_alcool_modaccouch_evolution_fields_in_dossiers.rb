class ChangeTabacAlcoolModaccouchEvolutionFieldsInDossiers < ActiveRecord::Migration
  def up
    %w(tabac alcool modaccouch evolution).each do |field|
      change_column :dossiers, :"#{field}", :string
    end
  end
  def down
    %w(tabac alcool modaccouch evolution).each do |field|
      change_column :dossiers, :"#{field}", :integer
    end
  end
end
