class Evolution < ActiveRecord::Base
  attr_accessible :name, :oldid, :libelle
  has_many :dossiers
end
