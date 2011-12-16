class Exposition < ActiveRecord::Base
  attr_accessible :expo_type_id, :produit_id, :indication_id, :de, :a, :duree, :de2, :a2, :duree2, :expo_nature_id, :dose, :expo_terme_id, :medpres
  belongs_to :produit
  belongs_to :dossier
  belongs_to :expo_type
  belongs_to :indication
  belongs_to :expo_terme
  belongs_to :expo_nature

  delegate :name, to: :produit, allow_nil: true, prefix: true
end
