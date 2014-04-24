class Exposition < ActiveRecord::Base
  belongs_to :produit, inverse_of: :expositions, counter_cache: true
  belongs_to :dossier, counter_cache: true
  belongs_to :expo_type
  belongs_to :indication, inverse_of: :expositions, counter_cache: true
  belongs_to :expo_terme
  belongs_to :expo_nature
  belongs_to :voie

  delegate :name, to: :indication, allow_nil: true, prefix: true
  delegate :name, to: :expo_terme, allow_nil: true, prefix: true

  validates_presence_of :produit

  ONNSP = [["Oui", "O"], ["Non", "N"], ["Ne sait pas", "NSP"]]

  def produit_name=(name)
    self.produit = Produit.find_by_name(name) unless name.blank?
  end

  def indication_name=(name)
    self.indication = Indication.find_by_name(name) unless name.blank?
  end
end
