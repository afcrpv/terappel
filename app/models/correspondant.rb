class Correspondant < ActiveRecord::Base
  belongs_to :specialite
  belongs_to :qualite
  belongs_to :formule
  belongs_to :centre

  has_many :demandeurs
  has_many :relances

  validates :nom, :prenom, :specialite_id, :cp, :ville, presence: true

  # callbacks
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
    update_attribute(:fullname, generate_fullname)
  end

  def generate_fullname
    [[nom.upcase, prenom].join(' '), specialite.name, cp, ville].compact.join(' - ')
  end
end
