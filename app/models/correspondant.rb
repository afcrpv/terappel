class Correspondant < ActiveRecord::Base
  attr_accessible :specialite_id, :qualite_id, :formule_id, :nom, :adresse, :cp, :ville, :telephone, :fax, :poste, :email, :fullname

  has_many :dossiers

  #callbacks
  after_create :assign_fullname
  before_update do
    self.fullname = create_fullname
  end

  private

  def assign_fullname
    self.update_attribute(:fullname, create_fullname)
  end

  def create_fullname
    [nom, cp, ville].join(" - ")
  end
end
