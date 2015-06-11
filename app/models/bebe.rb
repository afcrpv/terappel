class Bebe < ActiveRecord::Base
  attr_accessor :malformation_tokens, :pathology_tokens

  has_many :bebes_malformations, dependent: :destroy
  has_many :malformations, through: :bebes_malformations

  has_many :bebes_pathologies, dependent: :destroy
  has_many :pathologies, through: :bebes_pathologies

  belongs_to :dossier, counter_cache: true

  SEXE = [
    ['Masculin', 'M'],
    ['Féminin', 'F'],
    ['Inconnu', 'I'],
    ['Indéterminé', 'Id']
  ]

  def apgar
    contents = []
    contents.push apgar1 if apgar1.present?
    contents.push apgar5 if apgar1.present?
    contents.join(' - ')
  end

  def malformation_tokens=(ids)
    self.malformation_ids = ids.split(',')
  end

  def pathology_tokens=(ids)
    self.pathology_ids = ids.split(',')
  end

  %w(malformation pathology).each do |association|
    define_method "#{association}_names" do
      associations = self.send("#{association}s")
      if associations.any?
        associations.map(&:libelle).to_sentence
      end
    end
  end
end
