class Bebe < ActiveRecord::Base
  attr_accessible :malforma, :patho, :sexe, :poids, :apgar1, :apgar5, :pc, :taille

  belongs_to :dossier
end
