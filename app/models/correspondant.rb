class Correspondant < ActiveRecord::Base
  attr_accessible :specialite_id, :qualite_id, :formule_id, :nom, :adresse, :cp, :ville, :telephone, :fax, :poste, :email, :fullname

  has_many :dossiers
  belongs_to :specialite
  belongs_to :qualite
  belongs_to :formule

  validates_presence_of :nom

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
