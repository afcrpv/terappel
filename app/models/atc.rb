class Atc < ActiveRecord::Base
  has_many :produits, through: :classifications
  has_many :classifications, dependent: :destroy

  def to_s
    [libabr, libelle].join(" - ")
  end
end
