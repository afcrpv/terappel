class Malformation < ActiveRecord::Base
  has_ancestry

  validates_presence_of :libelle
  validates_uniqueness_of :libelle

  has_many :bebes_malformations, dependent: :destroy
  has_many :bebes, through: :bebes_malformations

  def to_s
    libelle
  end

  def libelle_and_id
    { id: id, text: libelle }
  end
end
