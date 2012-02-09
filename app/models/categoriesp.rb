class Categoriesp < ActiveRecord::Base
  attr_accessible :name, :oldid
  has_many :dossiers
  validates_presence_of :name

  default_scope order(:name)
end