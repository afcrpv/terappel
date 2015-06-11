class Correspondant < ActiveRecord::Base
  belongs_to :specialite
  belongs_to :qualite
  belongs_to :formule
  belongs_to :centre

  has_many :demandeurs
  has_many :relances

  validates_presence_of :nom

  #callbacks
  after_create :assign_fullname
  before_update do
    self.fullname = generate_fullname
  end

  def to_s
    fullname
  end

  def fullname_and_id
    { id: id, text: fullname }
  end

  private

  def assign_fullname
    self.update_attribute(:fullname, generate_fullname)
  end

  def generate_fullname
    [nom, specialite.name, cp, ville].compact.join(" - ")
  end
end
