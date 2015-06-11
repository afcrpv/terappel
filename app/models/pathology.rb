class Pathology < ActiveRecord::Base
  has_ancestry
  validates :libelle, presence: true, uniqueness: true

  has_many :bebes_pathologies, dependent: :destroy
  has_many :bebes, through: :bebes_pathologies

  def libelle_and_id
    { id: id, text: libelle }
  end
end
