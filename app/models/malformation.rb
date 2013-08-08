class Malformation < ActiveRecord::Base
  has_ancestry

  validates_presence_of :libelle
  validates_uniqueness_of :libelle

  has_and_belongs_to_many :bebes

  def libelle_and_id
    {'id' => id, 'text' => libelle}
  end
end
