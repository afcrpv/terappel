class Pathologie < ActiveRecord::Base
  has_ancestry
  validates :libelle, presence: true, uniqueness: true

  has_and_belongs_to_many :bebes

  def libelle_and_id
    return {"id" => id, "text" => libelle}
  end
end
