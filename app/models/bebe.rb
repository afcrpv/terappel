#encoding: utf-8
class Bebe < ActiveRecord::Base
  attr_accessible :malformation, :pathologie, :sexe, :poids, :apgar1, :apgar5, :pc, :taille, :malformation_tokens, :pathologie_tokens, :age

  attr_reader :malformation_tokens, :pathologie_tokens

  has_and_belongs_to_many :malformations
  has_and_belongs_to_many :pathologies

  belongs_to :dossier

  SEXE = [["Masculin", "M"], ["Féminin", "F"], ["Inconnu", "I"], ["Indéterminé", nil]]

  def malformation_tokens=(ids)
    self.malformation_ids = ids.split(",")
  end

  def pathologie_tokens=(ids)
    self.pathologie_ids = ids.split(",")
  end

  %w(malformation pathologie).each do |association|
    define_method "#{association}_names" do
      associations = self.send("#{association}s")
      if associations.any?
        associations.map(&:libelle).to_sentence
      end
    end
  end
end
