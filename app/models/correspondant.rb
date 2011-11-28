class Correspondant < ActiveRecord::Base
  attr_accessible :specialite_id, :qualite_id, :formule_id, :nom, :adresse, :cp, :ville, :telephone, :fax, :poste, :email

  has_many :dossiers
end
