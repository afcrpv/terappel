class Exposition < ActiveRecord::Base
  belongs_to :produit
  belongs_to :dossier
  belongs_to :expo_type
  belongs_to :indication
  belongs_to :expo_terme
  belongs_to :expo_nature
end
