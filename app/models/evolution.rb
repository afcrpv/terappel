class Evolution < ActiveRecord::Base
  attr_accessible :name, :oldid
  has_many :dossiers
end