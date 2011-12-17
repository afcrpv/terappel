class Malformation < ActiveRecord::Base
  attr_accessible :libelle, :libabr

  validates_presence_of :libelle

  has_and_belongs_to_many :bebes

  def libelle_and_id
    return {"id" => id, "libelle" => libelle}
  end
end
