class Categoriesp < ActiveRecord::Base
  has_many :dossiers
  validates_presence_of :name

  default_scope { order(:name) }

  def to_s
    name
  end
end
