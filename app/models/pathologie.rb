class Pathologie < ActiveRecord::Base
  has_ancestry
  attr_accessible :libelle, :libabr, :level, :ancestry, :parent_id, :codeterme, :codetermepere

  validates_presence_of :libelle
  validates_uniqueness_of :libelle

  has_and_belongs_to_many :bebes

  def libelle_and_id
    return {"id" => id, "libelle" => libelle}
  end
end
