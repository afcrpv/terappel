class Exposition < ActiveRecord::Base
  attr_accessible :expo_type_id, :produit_name, :indication_name, :de, :a, :duree, :de2, :a2, :duree2, :expo_nature_id, :dose, :expo_terme_id, :medpres
  belongs_to :produit
  belongs_to :dossier
  belongs_to :expo_type
  belongs_to :indication
  belongs_to :expo_terme
  belongs_to :expo_nature

  delegate :name, to: :produit, allow_nil: true, prefix: true

  ONNSP = [["Oui", "O"], ["Non", "N"], ["Ne sait pas", "NSP"]]

  def produit_name
    produit.name if produit
  end
  def produit_name=(name)
    self.produit = Produit.find_by_name(name) unless name.blank?
  end
  def indication_name
    indication.name if indication
  end
  def indication_name=(name)
    self.indication = Indication.find_by_name(name) unless name.blank?
  end
end
