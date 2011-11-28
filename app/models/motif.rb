class Motif < ActiveRecord::Base
  attr_accessible :name
  
  has_many :dossiers
end
