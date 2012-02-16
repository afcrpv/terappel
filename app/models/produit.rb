class Produit < ActiveRecord::Base
  attr_accessible :name, :oldid
  has_many :expositions
  has_many :dossiers, :through => :expositions

  default_scope order(:name)
end
