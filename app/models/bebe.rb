class Bebe < ActiveRecord::Base
  attr_accessible :malforma, :patho, :sexe, :poids, :apgar1, :apgar5, :pc, :taille, :malformation_tokens

  attr_reader :malformation_tokens

  has_and_belongs_to_many :malformations

  belongs_to :dossier

  def malformation_tokens=(ids)
    self.malformation_ids = ids.split(",")
  end

  def malformation_names
    if malformations.any?
      malformations.map(&:libelle).to_sentence
    end
  end
end
