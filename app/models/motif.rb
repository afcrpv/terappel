class Motif < ActiveRecord::Base
  attr_accessible :name, :oldid

  has_many :dossiers

  default_scope order(:name)
end
