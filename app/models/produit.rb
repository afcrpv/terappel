class Produit < ActiveRecord::Base
  attr_accessible :name
  has_many :expositions
  has_many :dossiers, :through => :expositions
end
